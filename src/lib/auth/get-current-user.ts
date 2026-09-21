import { createClient } from "@/lib/supabase/server";
import { prisma } from "@/lib/prisma";

export async function getCurrentUser() {
  const supabase = await createClient();

  const {
    data: { user: authUser },
    error,
  } = await supabase.auth.getUser();

  if (error || !authUser) {
    return null;
  }

  const user = await prisma.user.findUnique({
  where: { authUserId: authUser.id },
  include: {
    roles: true,
    department: true,
  },
});

  return user;
}