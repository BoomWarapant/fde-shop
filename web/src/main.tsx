import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter, Link, Route, Routes } from "react-router";
import { Layout, RequireRole, RequireSignIn } from "./components/Layout";
import "./index.css";
import { AuthProvider } from "./lib/auth";
import { AdminCampaignsPage, AdminHomePage, AdminUsersPage } from "./pages/Admin";
import { CartPage } from "./pages/Cart";
import { CatalogPage } from "./pages/Catalog";
import { LoginPage, RegisterPage } from "./pages/Login";
import { MyOrdersPage, OrderPage } from "./pages/Orders";
import { ProductPage } from "./pages/Product";
import { SellerAccountingPage, SellerCustomersPage, SellerHomePage, SellerOrdersPage, SellerProductsPage, SellerPromotionsPage } from "./pages/Seller";

const queryClient = new QueryClient({ defaultOptions: { queries: { staleTime: 30_000, refetchOnWindowFocus: false, retry: 1 } } });

function NotFound() {
  return <div className="py-16 text-center"><h1 className="text-xl font-semibold">Page not found</h1><Link to="/" className="mt-2 inline-block text-sm text-accent hover:underline">Back to the shop</Link></div>;
}

const buyer = (el: React.ReactNode) => <RequireRole role="buyer">{el}</RequireRole>;
const seller = (el: React.ReactNode) => <RequireRole role="seller">{el}</RequireRole>;
const admin = (el: React.ReactNode) => <RequireRole role="admin">{el}</RequireRole>;

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <BrowserRouter>
          <Routes>
            <Route element={<Layout />}>
              <Route index element={<CatalogPage />} />
              <Route path="shops/:id" element={<CatalogPage />} />
              <Route path="products/:id" element={<ProductPage />} />
              <Route path="login" element={<LoginPage />} />
              <Route path="register" element={<RegisterPage />} />
              <Route path="cart" element={buyer(<CartPage />)} />
              <Route path="orders" element={buyer(<MyOrdersPage />)} />
              <Route path="orders/:id" element={<RequireSignIn><OrderPage /></RequireSignIn>} />
              <Route path="seller" element={seller(<SellerHomePage />)} />
              <Route path="seller/products" element={seller(<SellerProductsPage />)} />
              <Route path="seller/orders" element={seller(<SellerOrdersPage />)} />
              <Route path="seller/promotions" element={seller(<SellerPromotionsPage />)} />
              <Route path="seller/accounting" element={seller(<SellerAccountingPage />)} />
              <Route path="seller/customers" element={seller(<SellerCustomersPage />)} />
              <Route path="admin" element={admin(<AdminHomePage />)} />
              <Route path="admin/users" element={admin(<AdminUsersPage />)} />
              <Route path="admin/campaigns" element={admin(<AdminCampaignsPage />)} />
              <Route path="*" element={<NotFound />} />
            </Route>
          </Routes>
        </BrowserRouter>
      </AuthProvider>
    </QueryClientProvider>
  </StrictMode>,
);
