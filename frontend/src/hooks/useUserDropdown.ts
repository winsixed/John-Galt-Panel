"use client";
import { useState, useCallback } from "react";

export const useUserDropdown = () => {
  const [isOpen, setIsOpen] = useState(false);

  const toggleDropdown = useCallback(
    (e?: React.MouseEvent<HTMLButtonElement>) => {
      e?.stopPropagation();
      setIsOpen((prev) => !prev);
    },
    []
  );

  const closeDropdown = useCallback(() => setIsOpen(false), []);

  return { isOpen, toggleDropdown, closeDropdown } as const;
};
