"use client";
import React, { createContext, useContext, useEffect, useState } from "react";
import { Role } from "@/types";

export type User = {
  id: number;
  email: string;
  role: Role;
};

interface AuthContextType {
  user: User | null;
  setUser: (user: User | null) => void;
  login: (token: string) => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | null>(null);

interface TokenPayload {
  sub: string;
  email?: string;
  role: Role;
  exp: number;
}

function parseJwt(token: string): TokenPayload | null {
  try {
    const base64 = token.split(".")[1].replace(/-/g, "+").replace(/_/g, "/");
    return JSON.parse(atob(base64)) as TokenPayload;
  } catch {
    return null;
  }
}

function getCookie(name: string): string | null {
  if (typeof document === "undefined") return null;
  const match = document.cookie.match(new RegExp(`(^| )${name}=([^;]+)`));
  return match ? match[2] : null;
}

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [user, setUser] = useState<User | null>(null);

  const login = (token: string) => {
    const payload = parseJwt(token);
    if (payload && payload.exp * 1000 > Date.now()) {
      setUser({
        id: parseInt(payload.sub),
        email: payload.email ?? "",
        role: payload.role as Role,
      });
      localStorage.setItem("token", token);
      document.cookie = `token=${token}; path=/; SameSite=Lax`;
    } else {
      setUser(null);
      localStorage.removeItem("token");
      document.cookie = "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
    }
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem("token");
    document.cookie = "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
  };

  useEffect(() => {
    const stored =
      typeof window !== "undefined" ? localStorage.getItem("token") : null;
    const cookieToken = getCookie("token");
    const token = stored || cookieToken;
    if (token) {
      const payload = parseJwt(token);
      if (payload && payload.exp * 1000 > Date.now()) {
        login(token);
      } else {
        localStorage.removeItem("token");
        document.cookie = "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
      }
    }
  }, []);

  return (
    <AuthContext.Provider value={{ user, setUser, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
};
