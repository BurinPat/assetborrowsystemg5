import express from "express";
import db from "../db.js";
import { verifyToken, authorizeRole } from "./verifyToken.js";

const router = express.Router();

// Student ดูประวัติของตัวเอง
router.get("/history/:student_id", verifyToken, authorizeRole("student"), (req, res) => {
  const { student_id } = req.params;
  const sql = `
    SELECT a.name AS asset, b.status, b.borrow_date, b.return_date
    FROM borrow_history b
    JOIN assets a ON b.asset_id = a.id
    WHERE b.student_id = ?`;
  db.query(sql, [student_id], (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json(results);
  });
});

// Staff / Lecturer ดูประวัติทั้งหมด
router.get("/history", verifyToken, authorizeRole("staff", "lecturer"), (req, res) => {
  const sql = `
    SELECT u.username, a.name AS asset, b.status, b.borrow_date, b.return_date
    FROM borrow_history b
    JOIN users u ON b.student_id = u.id
    JOIN assets a ON b.asset_id = a.id`;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json(results);
  });
});

export default router;
