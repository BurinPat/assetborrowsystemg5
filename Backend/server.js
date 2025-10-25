import express from "express";
import cors from "cors";
import path from "path";
import { fileURLToPath } from "url";

// import routes
import authRoutes from "./routes/auth.js";
import assetRoutes from "./routes/assets.js";
import borrowRoutes from "./routes/borrow.js";
import historyRoutes from "./routes/history.js";
import dashboardRoutes from "./routes/dashboard.js";

const app = express();
app.use(cors());
app.use(express.json());

// สำหรับให้ Flutter / Web โหลดภาพได้
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Register routes
app.use("/api", authRoutes);
app.use("/api", assetRoutes);
app.use("/api", borrowRoutes);
app.use("/api", historyRoutes);
app.use("/api", dashboardRoutes);

// Health check
app.get("/", (req, res) => {
  res.send("🚀 Asset System API is running...");
});

// Server configuration
const PORT = 5000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
