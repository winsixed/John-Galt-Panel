import { NextRequest, NextResponse } from 'next/server';

const PROTECTED = [
  '/dashboard',
  '/admin',
  '/inventory',
  '/settings',
  '/profile',
  '/users'
];

function parseJwt(token: string) {
  try {
    const base64 = token.split('.')[1].replace(/-/g, '+').replace(/_/g, '/');
    return JSON.parse(Buffer.from(base64, 'base64').toString());
  } catch {
    return null;
  }
}

export function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl;
  if (PROTECTED.some((p) => pathname.startsWith(p))) {
    const token = req.cookies.get('token')?.value;
    if (!token) {
      return NextResponse.redirect(new URL('/login', req.url));
    }
    const payload = parseJwt(token);
    if (!payload || (payload.role !== 'admin' && payload.role !== 'staff')) {
      return NextResponse.redirect(new URL('/unauthorized', req.url));
    }
  }
  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*','/admin/:path*','/inventory/:path*','/settings/:path*','/profile/:path*','/users/:path*']
};
