import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

const API = process.env.SHOP_API ?? "http://127.0.0.1:8020";

export default defineConfig({
  plugins: [react(), tailwindcss()],
  // /api is proxied to the FastAPI server
  server: { port: 5190, proxy: { "/api": API } },
});
