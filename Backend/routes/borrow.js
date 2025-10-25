import express from "express";
import db from "../db.js";
import { verifyToken, authorizeRole } from "./verifyToken.js";

const router = express.Router();

// นักศึกษายืม
router.post("/borrow", verifyToken, authorizeRole("student"), (req, res) => {
  const { asset_id } = req.body;
  const student_id = req.user.id;

  const sql =
    "INSERT INTO borrow_history (asset_id, student_id, status) VALUES (?, ?, 'Pending')";
  db.query(sql, [asset_id, student_id], (err) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json({ message: "Borrow request created (Pending)" });
  });
});

// อนุมัติการยืม (Staff)
router.put("/borrow/approve/:id", verifyToken, authorizeRole("staff"), (req, res) => {
  const { id } = req.params;
  const sql = "UPDATE borrow_history SET status='Borrowed' WHERE id=?";
  db.query(sql, [id], (err) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json({ message: "Borrow approved" });
  });
});

// นักศึกษาคืน
router.put("/return/:id", verifyToken, authorizeRole("student"), (req, res) => {
  const { id } = req.params;
  const sql = "UPDATE borrow_history SET status='Returned' WHERE id=?";
  db.query(sql, [id], (err) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json({ message: "Item returned successfully" });
  });
});

// อนุมัติการคืน (Staff)
router.put("/return/approve/:id", verifyToken, authorizeRole("staff"), (req, res) => {
  const { id } = req.params;
  const sql = "UPDATE borrow_history SET status='Returned' WHERE id=?";
  db.query(sql, [id], (err) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json({ message: "Return approved" });
  });
});

export default router;
