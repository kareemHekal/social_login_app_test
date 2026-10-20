import { createRemoteJWKSet, jwtVerify } from 'jose';

interface Env {
  LEGACY_URL: string;
  FIREBASE_PROJECT_ID: string;
  SERVER_SECRET: string;
}

const JWKS = createRemoteJWKSet(
  new URL('https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com')
);

const json = (data: unknown, status = 200) =>
  new Response(JSON.stringify(data), { status, headers: { 'Content-Type': 'application/json' } });

const enc = (s: string) => new TextEncoder().encode(s);

async function derivePassword(secret: string, email: string) {
  const key = await crypto.subtle.importKey('raw', enc(secret), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const sig = await crypto.subtle.sign('HMAC', key, enc('social:' + email.toLowerCase()));
  const b64 = btoa(String.fromCharCode(...new Uint8Array(sig))).replace(/[+/=]/g, '').slice(0, 32);
  return `Aa1!${b64}`;
}

const callLegacy = (env: Env, path: string, body: object) =>
  fetch(`${env.LEGACY_URL}/api/v1/auth/${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });

async function verify(token: string, env: Env) {
  const { payload } = await jwtVerify(token, JWKS, {
    issuer: `https://securetoken.google.com/${env.FIREBASE_PROJECT_ID}`,
    audience: env.FIREBASE_PROJECT_ID,
  });
  if (!payload.email || !payload.email_verified) throw new Error('email not verified');
  return String(payload.email).toLowerCase();
}

export default {
  async fetch(req: Request, env: Env): Promise<Response> {
    const { pathname } = new URL(req.url);
    if (req.method !== 'POST') return json({ message: 'not found' }, 404);

    const body = await req.json<any>().catch(() => ({} as any));
    if (!body.token) return json({ message: 'token required' }, 400);

    let email: string;
    try {
      email = await verify(body.token, env);
    } catch {
      return json({ message: 'invalid token' }, 401);
    }
    const password = await derivePassword(env.SERVER_SECRET, email);

    if (pathname === '/social/login') {
      const res = await callLegacy(env, 'signin', { email, password });
      if (res.ok) return new Response(res.body, { status: 200, headers: { 'Content-Type': 'application/json' } });
      return json({ message: 'not_registered' }, 404);
    }

    if (pathname === '/social/register') {
      if (!body.profile) return json({ message: 'profile required' }, 400);
      const res = await callLegacy(env, 'signup', { ...body.profile, email, password, rePassword: password });
      return new Response(res.body, { status: res.status, headers: { 'Content-Type': 'application/json' } });
    }

    return json({ message: 'not found' }, 404);
  },
};