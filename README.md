# Test Deposit
* เริ่มต้นทำการดึงข้อมูลจาก http://test.blockfint.com/salary.json  และสร้างไฟล์ชื่อ employee.json ใน folder
* เรียงลำดับข้อมูลตาม salary จากมากไปน้อย
* นำ id ของ 3 คน ที่มีเงินเดือนมากที่สุดไปเก็บไว้ใน list
* สร้าง list เก็บ id ของ 3 คน ที่มีเงินเดือนมากที่สุด
* สร้าง list เก็บยอดฝากเงินของ 3 คน ที่มีเงินเดือนมากที่สุด

## ทดสอบการฝากเงินในระบบ
* เข้า http://test.blockfint.com/
* search เพื่อหายอดเงินของแต่ละ id
* deposit เงินตามยอด Deposit แต่ละยอดของแต่ละ id
* เช็คว่ายอดเงินแต่ละครั้งหลัง deposit เป็นยอดเงินที่ถูกต้อง
> - ถ้าหากพบว่ายอดเงินไม่ถูกต้องระบบจะมี pop-up ให้เลือกว่าจะทำการทดสอบต่อหรือระบุว่าการทดสอบ fail
> - ถ้าเลือกให้การทดสอบ fail จะมีการให้กรอกข้อความเพื่อแจ้งบน terminal 
