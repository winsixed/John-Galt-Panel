"use client";
import React, { createContext, useContext, useEffect, useState } from "react";

type Role = "admin" | "staff" | "viewer";

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
      document.cookie = `token=${token}; path=/; secure`;
    } else {
      setUser(null);
      localStorage.removeItem("token");
    }
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem("token");
    document.cookie = "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
  };

  useEffect(() => {
    const stored = localStorage.getItem("token");
    let token = stored;
    if (!token) {
      const match = document.cookie.match(/(?:^|; )token=([^;]*)/);
      if (match) token = match[1];
    }
    if (token) {
      const payload = parseJwt(token);
      if (payload && payload.exp * 1000 > Date.now()) {
        login(token);
      } else {
        localStorage.removeItem("token");
        document.cookie =
          "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";
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
