import axios from "axios";

const BASE_URL = "http://localhost:3000/api";

async function testRepairAndFeedback() {
  console.log("--- Testing Repair Reporting & Feedback Flow (FE-03) ---");

  try {
    // 1. Setup Identities
    console.log("Step 1: Logging in as Resident (res_200)...");
    const resLogin = await axios.post(`${BASE_URL}/auth/login`, {
      email: "res_200@vivorn.com",
      password: "0406727509370"
    });
    const resToken = resLogin.data.token;

    console.log("Step 1.2: Logging in as Staff (Jurisdictic Admin)...");
    const staffLogin = await axios.post(`${BASE_URL}/auth/login`, {
      email: "admin@vivorn.com",
      password: "AdminP@ss123"
    });
    const staffToken = staffLogin.data.token;

    // 2. Create Repair Request
    console.log("Step 2: Resident creating a repair request...");
    const intentRes = await axios.post(`${BASE_URL}/repair/confirm`, {
      request: {
        tasks: [
          {
            object_id: "d8271a55-48ca-4c4f-ab11-268b8c132846",
            object_type: "Bathroom",
            description: "Leaking toilet",
            urgency: "normal"
          }
        ]
      }
    }, { headers: { Authorization: `Bearer ${resToken}` } });

    const requestId = intentRes.data.request_id;
    console.log("Request Created ID:", requestId);

    // Get the Task ID
    const taskQuery = await axios.post(`${BASE_URL}/dev/query`, {
      sql: "SELECT id FROM task WHERE request_id = ?",
      params: [requestId]
    });
    const taskId = taskQuery.data.data[0].id;
    console.log("Task ID found:", taskId);

    // 3. Technician Update Task to Completed
    console.log("Step 3: Technician reporting repair completion...");
    const reportRes = await axios.patch(`${BASE_URL}/repair/task/${taskId}`, {
      status: "Completed",
      task_report: "Fixed the valve and replaced the seal.",
      after_repair_image_url: "https://example.com/fixed_toilet.jpg"
    }, { headers: { Authorization: `Bearer ${staffToken}` } });

    console.log("Technician Report Result Status Code:", reportRes.data.status_code);

    // 4. Resident Submits Evaluation
    console.log("Step 4: Resident submitting evaluation...");
    const evalRes = await axios.post(`${BASE_URL}/repair/evaluate`, {
      request_id: requestId,
      rating: 5,
      comment: "Excellent service, very fast!"
    }, { headers: { Authorization: `Bearer ${resToken}` } });

    console.log("Evaluation Result Status Code:", evalRes.data.status_code);
    
    if (evalRes.data.status_code === "EVALUATION_SUBMITTED") {
      console.log(">>> FE-03 & Feedback System VERIFIED: Flow completed successfully.");
    }

  } catch (err: any) {
    console.error("Test Failed:", err.response?.data || err.message);
  }
}

testRepairAndFeedback();
