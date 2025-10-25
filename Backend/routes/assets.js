import express from "express";
import multer from "multer";
import path from "path";
import db from "../db.js";
import { verifyToken, authorizeRole } from "./verifyToken.js";

const router = express.Router();

// ตั้งค่าการอัปโหลดรูปภาพ
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, "uploads/"),
  filename: (req, file, cb) =>
    cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

// ดึงรายการครุภัณฑ์
router.get("/assets", verifyToken, (req, res) => {
  let sql = "SELECT * FROM assets";
  if (req.user.role === "student") sql += " WHERE status = 'Available'";
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json(results);
  });
});

// เพิ่มครุภัณฑ์ (เฉพาะ Staff)
router.post(
  "/assets",
  verifyToken,
  authorizeRole("staff"),
  upload.single("image"),
  (req, res) => {
    const { name, description, status } = req.body;
    const imageUrl = req.file ? `uploads/${req.file.filename}` : null;
    const sql =
      "INSERT INTO assets (name, description, status, image_url) VALUES (?, ?, ?, ?)";
    db.query(sql, [name, description, status, imageUrl], (err) => {
      if (err) return res.status(500).json({ message: "Database error" });
      res.status(201).json({ message: "Asset added successfully" });
    });
  }
);

// แก้ไขครุภัณฑ์ (เฉพาะ Staff)
router.put(
  "/assets/:id",
  verifyToken,
  authorizeRole("staff"),
  upload.single("image"),
  (req, res) => {
    const { id } = req.params;
    const { name, description, status } = req.body;
    const imageUrl = req.file ? `uploads/${req.file.filename}` : null;

    const sql = imageUrl
      ? "UPDATE assets SET name=?, description=?, status=?, image_url=? WHERE id=?"
      : "UPDATE assets SET name=?, description=?, status=? WHERE id=?";

    const values = imageUrl
      ? [name, description, status, imageUrl, id]
      : [name, description, status, id];

    db.query(sql, values, (err) => {
      if (err) return res.status(500).json({ message: "Database error" });
      res.json({ message: "Asset updated successfully" });
    });
  }
);

// ลบครุภัณฑ์ (เฉพาะ Staff)
router.delete("/assets/:id", verifyToken, authorizeRole("staff"), (req, res) => {
  const { id } = req.params;
  db.query("DELETE FROM assets WHERE id=?", [id], (err) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json({ message: "Asset deleted successfully" });
  });
});

export default router;
