# Project initiation
## Project details
### Title
I-Run
### Purpose

To simplify daily errands for IIUM Students such as sending or receiving documents, picking up parcels, sending an item to a friend, anything the sky is the limit.

---
### Target Audience
### 1. Errand Customers  
Errand customers are students who need tasks or errands completed but may not have the time or resources to do them themselves. These errands can range from simple tasks, like picking up documents from an office, to more specific requests, such as booking venues or purchasing items from nearby stores.  

**Key Characteristics:**  
- Busy with academic or personal commitments and need help managing daily errands.  
- May not have access to transportation or the ability to travel frequently around campus or nearby areas.  
- Require a simple, reliable, and affordable solution to delegate tasks efficiently.  
- Appreciate features like detailed task postings, secure payments, and real-time updates on task progress.  

**Example Use Cases:**  
1. A student needs help picking up an official letter from the Mahallah Office and delivering it to their dorm room.  
2. A student requests someone to book a venue at their Kulliyyah Office on their behalf due to overlapping commitments.  
3. A student needs items, such as snacks or toiletries, purchased and delivered from the Sri Gombak convenience store.  


### 2.Errand Runners  
Errand runners are students who take on tasks posted by errand customers. They aim to earn extra income, gain experience, or simply help their peers. The app acts as a platform to connect them with available jobs based on their preferences and availability.  

**Key Characteristics:**  
- Students who have flexible schedules and are looking for part-time opportunities or side income.  
- Tech-savvy individuals who can navigate the app efficiently to browse, filter, and accept tasks.  
- Motivated by convenience, proximity of tasks, and fair payment options.  
- May leverage the app to build a reputation through customer reviews, increasing their chances of securing more tasks.  

**Example Use Cases:**  
1. A student who has time between classes accepts tasks like printing documents for others at a nearby printing shop or campus facility.  
2. A student accepts tasks for booking venues or appointments at Kulliyyah Offices, especially for those unfamiliar with the process.  
3. A student with a car who often commutes to areas like Sri Gombak takes requests to buy and deliver items from convenience stores, offering reliable service for errands outside campus.
   
### Benefits for Both Groups  
- **Errand Customers:** Save time and effort while ensuring their tasks are completed quickly and securely.  
- **Errand Runners:** Gain a flexible source of income while providing value to the campus community.  

---


### Preferred platform
- As for preferred platform, we will be focusing on Android deployment first.
## Features

- 1.Post up an errand with details, locations, deadline and payment.
- 2.Ability for errand runners to browse and accept tasks based on filters such as location, urgency and type.

  
---
### 3.Manage Tasks
- **Task Creation**: Customers input task details like description, location, due date, price, urgency, and requirements.  
  _Example:_ A KICT student books the Human Science venue before Friday.
- **Editing and Completion**: Customers can edit, cancel, or mark tasks as completed, with feedback.
- **Notifications**: Runners get real-time updates to accept/decline tasks. Customers are notified of status changes.
- **Progress Tracking**: Customers track task status (e.g., "in progress," "done"), and runners update progress.

### 4.Integration with Payment System
- **Cash/QR Payment**: Payments made in cash or via QR after task completion. Confirmation (photo/signature) triggers payment.
- **Online Payment**: Supports FPX and Touch 'n Go e-wallet. Runners are paid automatically and can withdraw to bank/e-wallet.
- **Transaction History**: Both customers and runners can view payment history for task-related disputes or resolution.

### 5.User Profiles with Reviews
- **Errand Customers**: Profiles include contact, preferences, past tasks, and matric card verification for legitimacy.
- **Errand Runners**: Profiles show skills, availability, payment options, and a profile picture to build trust.
- **Rating System**: After task completion, customers rate errand runners from 1 to 5 stars based on performance, reliability, and communication.



---
### 6.Notification for updates and deadlines of errands.
- **Customizable notification**: Runners can customize and set the kind of tasks and errands they prefer to perform and get notified whenever there is a errand related to their choosing.
- **Unclaimed task reminder**: Customers will receive timely reminders on their errands to ensure that errands that has not been completed or accepted by a runner, allowing them to cancel or reassign the task to ensure timely completion.
---
### 7.Premium feature for premium users
- **Priority task matching**: Priority queue features for premium users allow their errands to be picked up faster than normal ones.
- **Unlimited Errands**: Normal users are limited to a number of errands per month, with premium users are allowed to create unlimited number of tasks.
- 8.Commission based fees (5-10% of payments).

## Business Model Canvas
TODO: INSERT BMC AND ROI HERE

# Requirements Analysis
## Technical Feasibility and backend assessment
- The project will be utilizing the features provided by Firebase to complete requirements in our project.
### Registeration and login
- The project will utilize the authentication module which is provided in Firebase. Using these module, it will allow our application to be able to handle user registeration and login gracefully using Firebase authentication. The module also offers the ability to log in using other providers such as Microsoft and google email.
### Data storage operations
- As for the database operations, we will be utilizing the Firestore database module which is provided in Firebase. The module will be using NoSQL for the database operations.
### Analytics
- As for analyzing the usage and operations of the application, we will be utilizing the Analytics Dashboard.
### Packages and plugins
- As for the plugins and packages currently are the listed one that are essential
```txt
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.2
  cloud_firestore: ^5.4.5
```
- The firebase_core and firebase_auth is eseential for providing connectivity to Firebase and providing authentication to users.
- cloud_firestore will be plugin responsible for CRUD operations connectivity.

