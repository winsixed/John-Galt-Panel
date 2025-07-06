"use client";
import { useAuth } from "@/context/AuthContext";
import LogoutButton from "@/components/auth/LogoutButton";
import React, { useState } from "react";
import { Dropdown } from "../ui/dropdown/Dropdown";
import { DropdownItem } from "../ui/dropdown/DropdownItem";

export default function UserDropdown() {
  const [isOpen, setIsOpen] = useState(false);
  const { user } = useAuth();

  function toggleDropdown(e: React.MouseEvent<HTMLButtonElement, MouseEvent>) {
    e.stopPropagation();
    setIsOpen((prev) => !prev);
  }

  function closeDropdown() {
    setIsOpen(false);
  }

  const avatarUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(user?.username || "User")}&background=0D8ABC&color=fff&size=128`;

  return (
    <div className="relative">
      <button
        onClick={toggleDropdown}
        className="flex items-center text-gray-700 dark:text-gray-400 dropdown-toggle"
      >
        <div className="flex items-center gap-3">
          <span className="overflow-hidden rounded-full h-11 w-11">
            <img
              src={avatarUrl}
              alt="User"
              className="object-cover w-full h-full"
            />
          </span>
          <div className="hidden sm:block">
            <span className="block font-medium text-theme-sm text-gray-700 dark:text-gray-400">
              {user?.username || "Гость"}
            </span>
            <span className="block text-theme-xs text-gray-500 dark:text-gray-400 capitalize">
              {user?.role || "no-role"}
            </span>
          </div>
        </div>
        <svg
          className={`stroke-gray-500 dark:stroke-gray-400 transition-transform duration-200 ${
            isOpen ? "rotate-180" : ""
          }`}
          width="18"
          height="20"
          viewBox="0 0 18 20"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            d="M4.3125 8.65625L9 13.3437L13.6875 8.65625"
            stroke="currentColor"
            strokeWidth="1.5"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      </button>

      <Dropdown
        isOpen={isOpen}
        onClose={closeDropdown}
        className="absolute right-0 mt-[17px] flex w-[260px] flex-col rounded-2xl border border-gray-200 bg-white p-3 shadow-theme-lg dark:border-gray-800 dark:bg-gray-dark"
      >
        <div className="flex items-center gap-3">
          <span className="overflow-hidden rounded-full h-11 w-11">
            <img
              src={avatarUrl}
              alt="User"
              className="object-cover w-full h-full"
            />
          </span>
          <div>
            <span className="block font-medium text-theme-sm text-gray-700 dark:text-gray-400">
              {user?.username || "Гость"}
            </span>
            <span className="block text-theme-xs text-gray-500 dark:text-gray-400 capitalize">
              {user?.role || "no-role"}
            </span>
          </div>
        </div>

        <ul className="flex flex-col gap-1 pt-4 pb-3 border-b border-gray-200 dark:border-gray-800">
          <li>
            <DropdownItem
              onItemClick={closeDropdown}
              tag="a"
              href="/profile"
              className="flex items-center gap-3 px-3 py-2 font-medium text-gray-700 rounded-lg group text-theme-sm hover:bg-gray-100 hover:text-gray-700 dark:text-gray-400 dark:hover:bg-white/5 dark:hover:text-gray-300"
            >
              <svg
                className="fill-gray-500 group-hover:fill-gray-700 dark:fill-gray-400 dark:group-hover:fill-gray-300"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M10.4858 3.5H13.5182C14.7519 3.5 15.7518 4.50019 15.7518 5.73399C15.7518 7.45312 17.6129 8.52817 19.102 7.66842C19.4528 7.46589 19.9014 7.58608 20.1039 7.93689L21.6203 10.5633C21.8229 10.9143 21.7027 11.3631 21.3517 11.5657C19.8625 12.4255 19.8625 14.5749 21.3517 15.4347C21.7026 15.6373 21.8229 16.086 21.6203 16.437L20.1039 19.0635C19.9013 19.4143 19.4528 19.5345 19.102 19.3319C17.6129 18.4722 15.7518 19.5472 15.7518 21.2664C15.7518 21.6716 15.4233 22 15.0182 22H12H8.98179C8.57666 22 8.24815 21.6715 8.24815 21.266C8.24815 19.5461 6.38616 18.4717 4.89699 19.3314C4.54577 19.5342 4.09669 19.4138 3.89399 19.0628L2.37799 16.437C2.17535 16.086 2.2956 15.6372 2.64658 15.4346C4.13581 14.5748 4.13578 12.4253 2.64657 11.5655C2.29558 11.3628 2.17533 10.914 2.37797 10.563L3.89396 7.93722C4.09666 7.58614 4.54575 7.46578 4.89697 7.66855C6.38614 8.52833 8.24814 7.45387 8.24814 5.73396C8.24814 4.32859 9.24833 3.3284 10.4821 3.3284H13.5146"
                  fill=""
                />
              </svg>
              Настройки
            </DropdownItem>
          </li>
        </ul>
        <LogoutButton />
      </Dropdown>
    </div>
  );
}
