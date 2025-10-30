import express from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import db from "../db.js";

const router = express.Router();
const SECRET_KEY = "mfu_asset_secret";

// REGISTER
router.post("/register", async (req, res) => {
  console.log("🟢 [REGISTER] Incoming body:", req.body);
  const { full_name, username, password, role } = req.body;

  if (!full_name || !username || !password || !role)
    return res.status(400).json({ message: "Missing fields" });

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const sql =
      "INSERT INTO users (full_name, username, password, role) VALUES (?, ?, ?, ?)";

    db.query(sql, [full_name, username, hashedPassword, role], (err) => {
      if (err) {
        console.error("❌ [REGISTER] Database error:", err);
        return res
          .status(500)
          .json({ message: "Database error", error: err.message });
      }
      console.log(`✅ [REGISTER] User '${username}' registered successfully`);
      res.status(201).json({ message: "User registered successfully" });
    });
  } catch (err) {
    console.error("❌ [REGISTER] Error:", err);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});

// LOGIN
router.post("/login", (req, res) => {
  console.log("🟡 [LOGIN] Request body:", req.body);
  const { username, password } = req.body;

  if (!username || !password)
    return res.status(400).json({ message: "Missing username or password" });

  const sql = "SELECT * FROM users WHERE username = ?";

  db.query(sql, [username], async (err, results) => {
    if (err) {
      console.error("❌ [LOGIN] Database error:", err);
      return res.status(500).json({ message: "Database error" });
    }

    if (results.length === 0) {
      console.warn(`⚠️ [LOGIN] User '${username}' not found`);
      return res.status(401).json({ message: "User not found" });
    }

    const user = results[0];
    console.log("🔍 [LOGIN] User found:", {
      id: user.id,
      username: user.username,
      role: user.role,
    });

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      console.warn(`⚠️ [LOGIN] Invalid password for user '${username}'`);
      return res.status(401).json({ message: "Invalid password" });
    }

    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      SECRET_KEY,
      { expiresIn: "2h" }
    );

    // ✅ LOG FULL RESPONSE BEFORE SENDING
    const responseData = {
      message: "Login successful",
      token,
      full_name: user.full_name,
      role: user.role,
      username: user.username,
    };
    console.log("✅ [LOGIN] Successful login → Sending response:", responseData);

    res.status(200).json(responseData);
  });
});

export default router;
