import Link from "next/link";
import {
  LayoutDashboard,
  ClipboardList,
  ShoppingCart,
  Building2,
  FileText,
  Package,
  Truck,
  Receipt,
  Settings,
  Hospital,
} from "lucide-react";

import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "@/components/ui/sidebar";

const mainMenu = [
  {
    title: "Dashboard",
    url: "/dashboard",
    icon: LayoutDashboard,
  },
];

const procurementMenu = [
  {
    title: "Talepler",
    url: "/dashboard/talepler",
    icon: ClipboardList,
  },
  {
    title: "Satın Alma",
    url: "/dashboard/satin-alma",
    icon: ShoppingCart,
  },
  {
    title: "Tedarikçiler",
    url: "/dashboard/tedarikciler",
    icon: Building2,
  },
  {
    title: "Teklifler",
    url: "/dashboard/teklifler",
    icon: FileText,
  },
];

const operationMenu = [
  {
    title: "Siparişler",
    url: "/dashboard/siparisler",
    icon: Package,
  },
  {
    title: "Teslimatlar",
    url: "/dashboard/teslimatlar",
    icon: Truck,
  },
  {
    title: "Faturalar",
    url: "/dashboard/faturalar",
    icon: Receipt,
  },
];

export function AppSidebar() {
  return (
    <Sidebar collapsible="icon">
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton size="lg" >
              <Link href="/dashboard">
                <div className="flex aspect-square size-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
                  <Hospital className="size-4" />
                </div>

                <div className="grid flex-1 text-left text-sm leading-tight">
                  <span className="truncate font-semibold">
                    Procurement
                  </span>
                  <span className="truncate text-xs text-muted-foreground">
                    Satın Alma Yönetimi
                  </span>
                </div>
              </Link>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>

      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupContent>
            <SidebarMenu>
              {mainMenu.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton  tooltip={item.title}>
                    <Link href={item.url}>
                      <item.icon />
                      <span>{item.title}</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        <SidebarGroup>
          <SidebarGroupLabel>Satın Alma</SidebarGroupLabel>

          <SidebarGroupContent>
            <SidebarMenu>
              {procurementMenu.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton
  tooltip={item.title}
  render={<Link href={item.url} />}
>
  <item.icon />
  <span>{item.title}</span>
</SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        <SidebarGroup>
          <SidebarGroupLabel>Operasyon</SidebarGroupLabel>

          <SidebarGroupContent>
            <SidebarMenu>
              {operationMenu.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton  tooltip={item.title}>
                    <Link href={item.url}>
                      <item.icon />
                      <span>{item.title}</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        <SidebarGroup>
          <SidebarGroupLabel>Sistem</SidebarGroupLabel>

          <SidebarGroupContent>
            <SidebarMenu>
              <SidebarMenuItem>
                <SidebarMenuButton  tooltip="Ayarlar">
                  <Link href="/dashboard/ayarlar">
                    <Settings />
                    <span>Ayarlar</span>
                  </Link>
                </SidebarMenuButton>
              </SidebarMenuItem>
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>

      <SidebarFooter>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton>
              <div className="flex size-7 items-center justify-center rounded-md bg-muted">
                <span className="text-xs font-semibold">U</span>
              </div>

              <div className="grid flex-1 text-left text-sm leading-tight">
                <span className="truncate font-medium">Kullanıcı</span>
                <span className="truncate text-xs text-muted-foreground">
                  Satın Alma
                </span>
              </div>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarFooter>
    </Sidebar>
  );
}