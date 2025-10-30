import express from "express";
import multer from "multer";
import path from "path";
import db from "../db.js";
import fs from "fs";
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
  authorizeRole("STAFF"),
  upload.single("image"),
  (req, res) => {
    const { name, status } = req.body;
    const imageUrl = req.file ? `/uploads/${req.file.filename}` : null;

    // ตรวจสอบค่าที่จำเป็น
    if (!name) {
      return res.status(400).json({ message: "Name is required" });
    }

    // ✅ ดึง code ล่าสุดจากฐานข้อมูล
    const getLastCodeSql = "SELECT code FROM assets ORDER BY id DESC LIMIT 1";
    db.query(getLastCodeSql, (err, results) => {
      if (err) {
        console.error("❌ Database Error (getLastCode):", err);
        return res.status(500).json({ message: "Database error" });
      }

      // ✅ สร้าง code ใหม่
      let newCode = "AS-001";
      if (results.length > 0 && results[0].code) {
        const lastCode = results[0].code; // ตัวอย่าง "AS-009"
        const lastNumber = parseInt(lastCode.split("-")[1]); // 9
        const nextNumber = lastNumber + 1;
        newCode = `AS-${nextNumber.toString().padStart(3, "0")}`; // "AS-010"
      }

      // ✅ บันทึกข้อมูลลงฐานข้อมูล
      const insertSql =
        "INSERT INTO assets (code, name, status, image_url) VALUES (?, ?, ?, ?)";
      db.query(
        insertSql,
        [newCode, name, status || "available", imageUrl],
        (err, result) => {
          if (err) {
            console.error("❌ Database Error (insert):", err);
            return res.status(500).json({ message: "Database error" });
          }

          res.status(201).json({
            message: "✅ Asset added successfully",
            asset: {
              id: result.insertId,
              code: newCode,
              name,
              status: status || "available",
              image_url: imageUrl,
            },
          });
        }
      );
    });
  }
);


// แก้ไขครุภัณฑ์ (เฉพาะ Staff)
router.put(
  "/assets/:id",
  verifyToken,
  authorizeRole("STAFF"),
  upload.single("image"),
  (req, res) => {
    const { id } = req.params;
    const { name, description, status } = req.body;
    const imageUrl = req.file ? `/uploads/${req.file.filename}` : null;

    // ✅ ดึงชื่อไฟล์เก่าก่อนอัปเดต
    const getOldImageSql = "SELECT image_url FROM assets WHERE id = ?";
    db.query(getOldImageSql, [id], (err, results) => {
      if (err) {
        console.error("❌ Database Error:", err);
        return res.status(500).json({ message: "Database error" });
      }

      const oldImagePath = results[0]?.image_url;

      // ✅ อัปเดตข้อมูลใหม่
      const sql = imageUrl
        ? "UPDATE assets SET name=?, description=?, status=?, image_url=? WHERE id=?"
        : "UPDATE assets SET name=?, description=?, status=? WHERE id=?";

      const values = imageUrl
        ? [name, description, status, imageUrl, id]
        : [name, description, status, id];

      db.query(sql, values, (err) => {
        if (err) {
          console.error("❌ Database Error:", err);
          return res.status(500).json({ message: "Database error" });
        }

        // ✅ ลบรูปเก่า (เฉพาะกรณีที่อัปโหลดใหม่)
        if (imageUrl && oldImagePath && fs.existsSync(path.join(process.cwd(), oldImagePath))) {
          fs.unlink(path.join(process.cwd(), oldImagePath), (err) => {
            if (err) console.error("⚠️ Failed to delete old image:", err);
            else console.log(`🗑️ Deleted old image: ${oldImagePath}`);
          });
        }

        res.json({ message: "✅ Asset updated successfully" });
      });
    });
  }
);

// ลบครุภัณฑ์ (เฉพาะ Staff)
router.delete("/assets/:id", verifyToken, authorizeRole("STAFF"), (req, res) => {
  const { id } = req.params;
  db.query("DELETE FROM assets WHERE id=?", [id], (err) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json({ message: "Asset deleted successfully" });
  });
});

export default router;
