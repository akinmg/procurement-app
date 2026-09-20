
import { UserRole } from "@/generated/prisma/client";
import { getCurrentUser } from "@/lib/auth";

export async function hasRole(role: UserRole): Promise<boolean> {
  const user = await getCurrentUser();

  if (!user) {
    return false;
  }

  return user.roles.some(
    (assignment: { role: UserRole }) => assignment.role === role
  );
}

export async function requireRole(
  ...roles: UserRole[]
) {
  const user = await getCurrentUser();

  if (!user) {
    throw new Error("UNAUTHORIZED");
  }

  const hasRequiredRole = user.roles.some(
    (assignment: { role: UserRole }) =>
      roles.includes(assignment.role)
  );

  if (!hasRequiredRole) {
    throw new Error("FORBIDDEN");
  }

  return user;
}

export async function requireAuth() {
  const user = await getCurrentUser();

  if (!user) {
    throw new Error("UNAUTHORIZED");
  }

  return user;
}
```
