# Exercise 3: Design a Workflow

**Estimated Time:** 3 minutes  
**Difficulty:** Easy ⭐

---

## 🎯 Objective

Design a simple n8n workflow on paper (or digitally) to solve one of your automation needs.

---

## 📋 Instructions

### Step 1: Choose Your Task

Pick ONE task from Exercise 2 (the one with highest ROI or most annoying).

**Task I'm automating:**
_________________________________

---

### Step 2: Identify the Trigger

**What event starts this workflow?**

Choose one:
- [ ] New email arrives
- [ ] Form is submitted
- [ ] Scheduled time (e.g., every day at 9 AM)
- [ ] Webhook (external service calls n8n)
- [ ] New file in folder
- [ ] Database record created
- [ ] Other: _________________________________

---

### Step 3: Map the Steps

Break down your workflow into individual nodes/steps.

Use this format:

```
[Trigger: What starts it]
        ↓
[Node 1: First action]
        ↓
[Node 2: Second action]
        ↓
[Node 3: Third action]
        ↓
[Node 4: Final action]
```

**Your workflow design:**

```
[Trigger: _________________________________]
        ↓
[Node 1: _________________________________]
        ↓
[Node 2: _________________________________]
        ↓
[Node 3: _________________________________]
        ↓
[Node 4: _________________________________]
        ↓
(Add more nodes if needed)
```

---

### Step 4: Add Conditional Logic (Optional)

Does your workflow need to make decisions?

**Do you need an IF/ELSE or conditional logic?**
- [ ] No, it's a simple linear flow
- [ ] Yes, I need to check something

If yes, describe the condition:

```
[Node: Check condition]
        ↓
    Is [condition]?
        ↓               ↓
       YES             NO
        ↓               ↓
[Action A]        [Action B]
```

**Your conditional logic:**
_________________________________

---

### Step 5: List Required Integrations

**What services/tools need to be connected?**

1. _________________________________
2. _________________________________
3. _________________________________
4. _________________________________

---

### Step 6: Define Success

**How do you know the workflow succeeded?**

Example: "PDF is saved in Google Drive AND team is notified on Slack"

**Success criteria:**
_________________________________

---

## 📝 Example: Invoice Processing

Here's a complete example for reference:

```
[Trigger: New email in Gmail with "invoice" in subject]
        ↓
[Node 1: Extract PDF attachment]
        ↓
[Node 2: Send PDF to OCR service to extract data]
        ↓
[Node 3: Create entry in accounting system (QuickBooks)]
        ↓
[Node 4: Save PDF to Google Drive/Invoices/2024/]
        ↓
[Node 5: Send Slack notification to #accounting]
```

**Integrations needed:**
- Gmail
- OCR service (e.g., Google Vision API)
- QuickBooks API
- Google Drive
- Slack

**Success:** Invoice data in QuickBooks + PDF in Drive + Team notified

---

## 💡 Reflection Questions

1. How many nodes does your workflow have?
   - _________________________________

2. Is this workflow simple or complex?
   - _________________________________

3. What's the most challenging part to automate?
   - _________________________________

4. Could this workflow run 100% automatically, or does it need human review?
   - _________________________________

---

## ✅ Completion Criteria

- [ ] Chose a task to automate
- [ ] Identified the trigger
- [ ] Mapped all workflow steps
- [ ] Listed required integrations
- [ ] Defined success criteria
- [ ] Answered reflection questions

---

## 🎉 Congratulations!

You've designed your first n8n workflow! Even though you can't build it yet (we haven't set up n8n), you now understand how to think in workflows.

**Save this design!** You'll build it for real once we finish the course.

---

**Next:** [Review Resources →](../resources/)

