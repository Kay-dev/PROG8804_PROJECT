# Todo Application - DevOps Capstone Project

A modern todo application built with React frontend and Node.js backend, featuring a comprehensive DevOps implementation including automated CI/CD pipelines, infrastructure as code, and cloud deployment on AWS ECS.

## Prerequisites

- Node.js (v14 or higher)
- npm (v6 or higher)
- Docker (for containerization)

## Project Structure

```
project/
├── frontend/          # React TypeScript frontend
├── backend/           # Node.js backend
├── terraform/         # Infrastructure as Code using Terraform
├── .github/           # GitHub Actions workflows for CI/CD
└── .aws/              # AWS task definitions
```

## DevOps Implementation

### 1. Application & Infrastructure Architecture

This project implements a modern microservices architecture deployed on AWS:

- **Frontend**: React single-page application deployed to Amazon ECS
- **Backend**: Node.js REST API deployed to Amazon ECS
- **Database**: Supabase for data persistence
- **Container Registry**: Amazon ECR for Docker image storage
- **Container Orchestration**: Amazon ECS for running containerized applications
- **Networking**: Application Load Balancer for traffic distribution

### 2. Infrastructure as Code (IaC)

The entire infrastructure is defined and provisioned using Terraform:

- **AWS Resources**: ECS clusters, ECR repositories, load balancers, and networking components
- **Configuration Management**: Environment variables and secrets handling
- **Security**: IAM roles and policies for secure access
- **Reproducibility**: Consistent environments through code

To deploy the infrastructure:

```bash
cd terraform
terraform init
terraform apply
```

### 3. Version Control Strategy

- **GitHub Repository**: Centralized source code management
- **Branching Strategy**: 
  - `main` - stable production code
  - `prod_8860` - production deployment branch
  - Feature branches for development
- **Code Reviews**: Pull request workflow for quality assurance
- **Protected Branches**: Safeguard critical branches from direct pushes

## Getting Started

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file:
   ```
   PORT=3004
   SUPABASE_URL=your-supabase-url
   SUPABASE_KEY=your-supabase-key
   ```

4. Start the backend server:
   ```bash
   npm start
   ```

The backend will be available at `http://localhost:3004`.

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file:
   ```
   REACT_APP_API_URL="http://localhost:3004"
   ```

4. Start the frontend development server:
   ```bash
   npm start
   ```

The application will open automatically in your default browser at `http://localhost:3000`.

## Testing

### Backend Testing

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Run the tests:
   ```bash
   npm test
   ```

### Frontend Testing

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Run the tests:
   ```bash
   npm test
   ```

## Features

- Create, read, update, and delete todos
- Mark todos as complete/incomplete
- Modern, responsive Material-UI interface
- RESTful API backend
- TypeScript support
- Docker containerization
- GitHub Actions CI/CD pipeline

## API Endpoints

- `GET /api/todos` - Get all todos
- `POST /api/todos` - Create a new todo
- `PUT /api/todos/:id` - Change a todo's status
- `DELETE /api/todos/:id` - Delete a todo

## Docker Support

Build the images:

```bash
# Backend
cd backend
docker build -t todo-backend .

# Frontend
cd frontend
docker build -t todo-frontend .
```

Run the containers:

```bash
# Backend
docker run -p 3004:3004 todo-backend

# Frontend
docker run -p 3000:3000 todo-frontend
```

### 4. CI/CD Pipeline Design

Fully automated pipelines implemented with GitHub Actions:

**Backend Pipeline Stages:**
1. **Code Checkout**: Retrieves source code from GitHub repository
2. **Environment Setup**: Configures Node.js runtime
3. **Code Scanning**: Static code analysis to identify issues
4. **Dependency Installation**: Installs required packages
5. **Testing**: Runs unit and integration tests
6. **AWS Authentication**: Configures AWS credentials
7. **Container Build & Push**: Creates Docker image and uploads to ECR
8. **Task Definition Update**: Updates ECS task definition with new image
9. **Deployment**: Deploys updated service to ECS

**Frontend Pipeline Stages:**
1. **Code Checkout**: Retrieves source code from GitHub repository
2. **Environment Setup**: Configures Node.js runtime
3. **Code Scanning**: Static code analysis to identify issues
4. **Dependency Installation**: Installs required packages
5. **Testing**: Runs unit and integration tests
6. **AWS Authentication**: Configures AWS credentials
7. **Container Build & Push**: Creates Docker image and uploads to ECR
8. **Task Definition Update**: Updates ECS task definition with new image
9. **Deployment**: Deploys updated service to ECS

### 5. Automated Triggers

The CI/CD pipelines are automatically triggered by:

- **Push Events**: Commits to the `prod_8860` branch
- **Path Filters**: Changes to specific directories:
  - Backend pipeline: Changes in `backend/` or related workflow files
  - Frontend pipeline: Changes in `frontend/` or related workflow files
- **Manual Trigger**: Via GitHub Actions workflow_dispatch event

### 6. Monitoring & Logging

- **AWS CloudWatch**: 
  - Container logs captured via `awslogs` driver
  - Custom log groups for each service (`/ecs/final-service-backend` and `/ecs/final-service-frontend`)
  - Automatic log group creation
  - Configured buffer size for efficient log handling
  - Regional log streaming with `ecs` prefix
- **Application Monitoring**: Health checks on deployed services
- **Deployment Monitoring**: Service stability verification

## Deployment

The application is automatically deployed through the CI/CD pipeline when changes are pushed to the `prod_8860` branch.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.
