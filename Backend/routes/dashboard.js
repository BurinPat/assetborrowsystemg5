import express from "express";
import db from "../db.js";
import { verifyToken, authorizeRole } from "./verifyToken.js";

const router = express.Router();

// สรุปจำนวนครุภัณฑ์แต่ละสถานะ
router.get("/dashboard/summary", verifyToken, authorizeRole("staff", "lecturer"), (req, res) => {
  const sql = `
    SELECT 
      SUM(status='Available') AS Available,
      SUM(status='Pending') AS Pending,
      SUM(status='Borrowed') AS Borrowed,
      SUM(status='Disabled') AS Disabled
    FROM assets`;

  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    res.json(results[0]);
  });
});

export default router;
