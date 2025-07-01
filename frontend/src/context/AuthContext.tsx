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
    } else {
      setUser(null);
      localStorage.removeItem("token");
    }
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem("token");
  };

  useEffect(() => {
    const stored = localStorage.getItem("token");
    if (stored) {
      const payload = parseJwt(stored);
      if (payload && payload.exp * 1000 > Date.now()) {
        login(stored);
      } else {
        localStorage.removeItem("token");
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
