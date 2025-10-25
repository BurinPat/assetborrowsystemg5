import mysql from "mysql2";

// เชื่อมต่อฐานข้อมูล MySQL (ใส่ค่าตรงนี้เลย)
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",             // ใส่รหัสผ่าน MySQL ของคุณ
  database: "assetsbrowsesystem"  // ชื่อฐานข้อมูล
});

db.connect(err => {
  if (err) {
    console.error("❌ Database connection failed:", err);
  } else {
    console.log("✅ Connected to MySQL Database");
  }
});

export default db;
