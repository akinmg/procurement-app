import "dotenv/config";

import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../src/generated/prisma/client";

const adapter = new PrismaPg({
  connectionString: process.env.DATABASE_URL!,
});

const prisma = new PrismaClient({
  adapter,
});

async function main() {
  const departments = [
    {
      code: "ECZ",
      name: "Eczane",
    },
    {
      code: "AYN",
      name: "Ayniyat",
    },
    {
      code: "BIO",
      name: "Biyomedikal",
    },
    {
      code: "TEK",
      name: "Teknik Servis",
    },
    {
      code: "BAS",
      name: "Başhekimlik",
    },
  ];

  for (const department of departments) {
    await prisma.department.upsert({
      where: {
        code: department.code,
      },
      update: {
        name: department.name,
      },
      create: department,
    });
  }

  const suppliers = [
    {
      supplierCode: "SUP-001",
      companyName: "Demo Medikal",
    },
    {
      supplierCode: "SUP-002",
      companyName: "Demo Sağlık",
    },
    {
      supplierCode: "SUP-003",
      companyName: "Demo Teknik",
    },
  ];

  for (const supplier of suppliers) {
    await prisma.supplier.upsert({
      where: {
        supplierCode: supplier.supplierCode,
      },
      update: {
        companyName: supplier.companyName,
      },
      create: supplier,
    });
  }

  console.log("Seed completed.");
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });