# Blockchain-Based Smart City Infrastructure Management

This project implements a set of smart contracts for managing urban infrastructure on the blockchain. It provides a decentralized approach to city asset management, maintenance scheduling, resource allocation, and performance analytics.

## Overview

The system consists of five main smart contracts:

1. **Asset Registration Contract**: Records details of urban infrastructure assets such as roads, bridges, buildings, utilities, and parks.
2. **Sensor Network Contract**: Manages IoT devices that monitor conditions of city infrastructure.
3. **Maintenance Scheduling Contract**: Optimizes repair and upkeep of city assets.
4. **Resource Allocation Contract**: Manages deployment of city services and resources.
5. **Performance Analytics Contract**: Tracks efficiency and service levels across the city.

## Smart Contracts

### Asset Registration Contract

The Asset Registration Contract allows city administrators to:
- Register new infrastructure assets
- Update asset status (operational, needs maintenance, under repair, decommissioned)
- Record maintenance activities
- Transfer ownership of assets

### Sensor Network Contract

The Sensor Network Contract enables:
- Registration of IoT sensors
- Recording sensor readings
- Updating sensor status
- Retrieving historical sensor data

### Maintenance Scheduling Contract

The Maintenance Scheduling Contract provides functionality to:
- Create maintenance tasks
- Assign tasks to maintenance crews
- Update task status
- Reassign tasks as needed

### Resource Allocation Contract

The Resource Allocation Contract manages:
- Registration of city resources (vehicles, equipment, personnel, budget)
- Allocation of resources to tasks
- Tracking resource usage
- Updating resource status

### Performance Analytics Contract

The Performance Analytics Contract tracks:
- Asset performance metrics
- City service metrics
- Citizen satisfaction scores
- Cost efficiency metrics

## Getting Started

### Prerequisites

- Clarity language environment
- Vitest for running tests

### Installation

1. Clone the repository
2. Install dependencies
3. Deploy contracts to your blockchain environment

### Testing

Run the tests using Vitest:

```bash
npm test
