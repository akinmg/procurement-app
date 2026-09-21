import {
  ClipboardList,
  ShoppingCart,
  Truck,
  Receipt,
} from "lucide-react";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const stats = [
  {
    title: "Bekleyen Talepler",
    value: "0",
    description: "Onay bekleyen talepler",
    icon: ClipboardList,
  },
  {
    title: "Aktif Satın Almalar",
    value: "0",
    description: "Devam eden işlemler",
    icon: ShoppingCart,
  },
  {
    title: "Bekleyen Teslimatlar",
    value: "0",
    description: "Teslimat bekleyen siparişler",
    icon: Truck,
  },
  {
    title: "Bekleyen Faturalar",
    value: "0",
    description: "İşlem bekleyen faturalar",
    icon: Receipt,
  },
];

export default function DashboardPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">
          Dashboard
        </h1>

        <p className="text-sm text-muted-foreground">
          Satın alma süreçlerinin genel görünümü
        </p>
      </div>

      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        {stats.map((stat) => (
          <Card key={stat.title}>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">
                {stat.title}
              </CardTitle>

              <stat.icon className="size-4 text-muted-foreground" />
            </CardHeader>

            <CardContent>
              <div className="text-2xl font-bold">{stat.value}</div>

              <p className="text-xs text-muted-foreground">
                {stat.description}
              </p>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Son İşlemler</CardTitle>
        </CardHeader>

        <CardContent>
          <p className="text-sm text-muted-foreground">
            Henüz gösterilecek işlem bulunmuyor.
          </p>
        </CardContent>
      </Card>
    </div>
  );
}