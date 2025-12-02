# Getting Started - Quick Start Guide

## 🚀 Start Here!

This guide will get you up and running in 10 minutes.

---

## Step 1: Install MySQL (5 minutes)

### Windows:
1. Download MySQL from [mysql.com/downloads](https://dev.mysql.com/downloads/)
2. Run installer
3. Choose "Developer Default"
4. Set root password (remember it!)
5. Complete installation

### Mac:
```bash
brew install mysql
brew services start mysql
```

### Linux:
```bash
sudo apt-get update
sudo apt-get install mysql-server
sudo mysql_secure_installation
```

---

## Step 2: Install MySQL Workbench (2 minutes)

1. Download from [mysql.com/products/workbench](https://dev.mysql.com/downloads/workbench/)
2. Install
3. Open MySQL Workbench
4. Connect to local MySQL server
   - Username: `root`
   - Password: (the one you set)

---

## Step 3: Create Your Database (1 minute)

In MySQL Workbench, run:

```sql
CREATE DATABASE sql_course;
USE sql_course;
```

---

## Step 4: Choose Your Learning Path

### Option A: Step-by-Step Tutorials (Recommended for Beginners)
Start with the `STEP_BY_STEP.md` file in each session:
1. [Session 1 - Step by Step](./Session_01_Window_Functions/STEP_BY_STEP.md)
2. [Session 2 - Step by Step](./Session_02_Optimization_Indexes/STEP_BY_STEP.md)
3. [Session 3 - Step by Step](./Session_03_Data_Analysis_BI/STEP_BY_STEP.md)
4. [Session 4 - Step by Step](./Session_04_Database_Design/STEP_BY_STEP.md)
5. [Session 5 - Step by Step](./Session_05_Case_Study/STEP_BY_STEP.md)

### Option B: Full Session Guides
Read the main README in each session folder for complete materials.

---

## Step 5: Install Tableau (For Session 3)

1. Download Tableau Public (free) from [tableau.com/public](https://public.tableau.com/)
2. Install
3. Create free account
4. You're ready for Session 3!

---

## 📚 How to Use This Course

### For Each Session:

1. **Read the STEP_BY_STEP.md** file
   - Follow along with examples
   - Run each query
   - Understand before moving on

2. **Try the exercises**
   - Don't look at solutions first
   - Try to solve yourself
   - Check solution if stuck

3. **Complete the challenge**
   - Apply what you learned
   - Create something real

4. **Review and practice**
   - Go back to concepts you didn't understand
   - Try variations
   - Experiment!

---

## 🎯 Session Order

Complete sessions in order:
1. **Session 1** - Window Functions (Foundation)
2. **Session 2** - Optimization (Make it fast)
3. **Session 3** - Data Analysis + Tableau (Visualize)
4. **Session 4** - Database Design (Build it right)
5. **Session 5** - Complete Project (Put it all together)

---

## 💡 Tips for Success

1. **Type, don't copy-paste**
   - You'll learn better by typing
   - Catch mistakes early

2. **Run queries often**
   - See results immediately
   - Understand what each part does

3. **Experiment**
   - Change values
   - Try different approaches
   - Break things (then fix them!)

4. **Take notes**
   - Write down what you learn
   - Create your own examples

5. **Ask questions**
   - If something doesn't make sense, re-read
   - Try to explain it to yourself

---

## ✅ Quick Check

Before starting, make sure you can:
- [ ] Connect to MySQL
- [ ] Run a simple SELECT query
- [ ] Create a table
- [ ] Insert data

If you can do these, you're ready!

---

## 🆘 Need Help?

### Common Issues:

**"Can't connect to MySQL"**
- Check if MySQL service is running
- Verify username/password
- Check port (default: 3306)

**"Query doesn't work"**
- Check for typos
- Verify table exists
- Check MySQL version (needs 8.0+ for some features)

**"Don't understand something"**
- Re-read the step
- Try a simpler example
- Look at the solution (it's okay!)

---

## 🎓 Ready to Start?

Go to [Session 1 - Step by Step](./Session_01_Window_Functions/STEP_BY_STEP.md) and begin!

**Good luck! You've got this!** 🚀

