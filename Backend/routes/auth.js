import express from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import db from "../db.js";

const router = express.Router();
const SECRET_KEY = "mfu_asset_secret";

// REGISTER
router.post("/register", async (req, res) => {
  console.log("Incoming body:", req.body);  
  const { full_name, username, password, role } = req.body;

  if (!full_name || !username || !password || !role)
    return res.status(400).json({ message: "Missing fields" });

  const hashedPassword = await bcrypt.hash(password, 10);
  const sql = "INSERT INTO users (full_name, username, password, role) VALUES (?, ?, ?, ?)";

  db.query(sql, [full_name, username, hashedPassword, role], (err) => {
    if (err) {
      console.error("❌ Database error:", err);
      return res.status(500).json({ message: "Database error", error: err.message });
    }
    res.status(201).json({ message: "User registered successfully" });
  });
});

// LOGIN
router.post("/login", (req, res) => {
  console.log("✅ Login request received:", req.body);
  const { username, password } = req.body;
  const sql = "SELECT * FROM users WHERE username = ?";

  db.query(sql, [username], async (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });
    if (results.length === 0)
      return res.status(401).json({ message: "User not found" });

    const user = results[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ message: "Invalid password" });

    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      SECRET_KEY,
      { expiresIn: "2h" }
    );

    res.status(200).json({
      message: "Login successful",
      token,
      role: user.role,
      username: user.username,
    });
  });
});

export default router;
