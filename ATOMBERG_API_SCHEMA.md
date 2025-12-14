# Atomberg IoT API Schema Documentation

## Base URL
```
https://api.developer.atomberg-iot.com
```

## Authentication
All requests require:
- `x-api-key`: Your API Key
- `Authorization`: Bearer token (Refresh Token for access token endpoint, Access Token for all others)

---

## 1. Get Access Token

### Endpoint
```
GET /v1/get_access_token
```

### Request Headers
```json
{
  "x-api-key": "your_api_key",
  "Authorization": "Bearer {refresh_token}"
}
```

### Response
```json
{
  "status": "Success",
  "message": {
    "access_token": "string",
    "expiry_timestamp": "number (Unix timestamp)"
  }
}
```

### Fields Used in App
- ✅ `status` - Validate success
- ✅ `message.access_token` - Stored for subsequent API calls
- ⚠️ `message.expiry_timestamp` - **NOT CURRENTLY USED** (should implement token refresh logic)

---

## 2. Get List of Devices

### Endpoint
```
GET /v1/get_list_of_devices
```

### Request Headers
```json
{
  "x-api-key": "your_api_key",
  "Authorization": "Bearer {access_token}"
}
```

### Response
```json
{
  "status": "Success",
  "message": {
    "devices_list": [
      {
        "device_id": "string",
        "name": "string",
        "room": "string",
        "model": "string",
        "series": "string",
        "color": "string",
        "metadata": {
          // Additional device metadata
        }
      }
    ]
  }
}
```

### Fields Used in App
- ✅ `status` - Validate success
- ✅ `message.devices_list` - Array of devices
- ✅ `device_id` - Unique identifier
- ✅ `name` - Device name (e.g., "Living Room Fan")
- ✅ `room` - Room name (e.g., "Living Room")
- ✅ `model` - Device model
- ✅ `series` - Device series
- ⚠️ `color` - **NOT CURRENTLY USED** (device color/appearance)
- ⚠️ `metadata` - **NOT CURRENTLY USED** (additional device info)

**Note:** This endpoint does NOT include device state (power, speed, online status). Must call `/get_device_state` separately.

---

## 3. Get Device State

### Endpoint
```
GET /v1/get_device_state?device_id={device_id}
```

### Request Headers
```json
{
  "x-api-key": "your_api_key",
  "Authorization": "Bearer {access_token}"
}
```

### Query Parameters
- `device_id` (required): Device ID to fetch state for

### Response
```json
{
  "status": "Success",
  "message": {
    "device_state": [
      {
        "device_id": "string",
        "power": "boolean",
        "last_recorded_speed": "number (1-6)",
        "sleep_mode": "boolean",
        "led": "boolean",
        "is_online": "boolean",
        "timer_hours": "number",
        "last_recorded_brightness": "number (10-100)",
        "last_recorded_color": "string (warm/cool/daylight)"
      }
    ]
  }
}
```

### Fields Used in App
- ✅ `status` - Validate success
- ✅ `message.device_state[0]` - First element of array
- ✅ `device_id` - Device identifier
- ✅ `power` - Power on/off state
- ✅ `last_recorded_speed` - Fan speed (1-6)
- ✅ `sleep_mode` - Sleep mode enabled
- ✅ `led` - Light on/off state
- ✅ `is_online` - Device connectivity status
- ✅ `timer_hours` - Timer setting in hours
- ✅ `last_recorded_brightness` - Light brightness (10-100%)
- ✅ `last_recorded_color` - Light color mode

**Note:** This response does NOT include `name` or `room`. App merges this with device list data.

---

## 4. Send Command

### Endpoint
```
POST /v1/send_command
```

### Request Headers
```json
{
  "x-api-key": "your_api_key",
  "Authorization": "Bearer {access_token}",
  "Content-Type": "application/json"
}
```

### Request Body
```json
{
  "device_id": "string",
  "command": {
    "key": "value"
  }
}
```

### Supported Commands

#### Power Control
```json
{"command": {"power": true}}  // or false
```

#### Speed Control
```json
{"command": {"speed": 3}}  // 1-6
```

#### Speed Delta (Increment/Decrement)
```json
{"command": {"speedDelta": 1}}   // +1 speed
{"command": {"speedDelta": -1}}  // -1 speed
```

#### Sleep Mode
```json
{"command": {"sleep": true}}  // or false
```

#### Timer
```json
{"command": {"timer": 2}}  // Hours (0 to disable)
```

#### LED Control
```json
{"command": {"led": true}}  // or false
```

#### Brightness Control
```json
{"command": {"brightness": 75}}  // 10-100
```

#### Brightness Delta
```json
{"command": {"brightnessDelta": 10}}   // +10
{"command": {"brightnessDelta": -10}}  // -10
```

#### Light Mode
```json
{"command": {"light_mode": "warm"}}    // warm, cool, daylight
```

### Commands Used in App
- ✅ `power` - Toggle fan on/off
- ✅ `speed` - Set fan speed (1-6)
- ✅ `sleep` - Toggle sleep mode
- ✅ `timer` - Set timer in hours
- ✅ `led` - Toggle light on/off
- ✅ `brightness` - Set light brightness (10-100)
- ✅ `light_mode` - Set color mode
- ⚠️ `speedDelta` - **NOT CURRENTLY USED** (could use for +/- buttons)
- ⚠️ `brightnessDelta` - **NOT CURRENTLY USED** (could use for +/- buttons)

### Response
```json
{
  "status": "Success",
  "message": "Command sent successfully"
}
```

---

## App Data Merging Strategy

Since device list and device state are separate endpoints, the app:

1. Fetches `/get_list_of_devices` → Gets `device_id`, `name`, `room`, `model`, `series`
2. For each device, fetches `/get_device_state` → Gets `power`, `speed`, `is_online`, etc.
3. Merges using `device.copyWith()` to preserve device info while adding state

---

## Potential Missing Features

### Not Currently Used:
1. **Token Expiry Management** - `expiry_timestamp` not tracked
2. **Device Color** - `color` field from device list
3. **Device Metadata** - `metadata` object from device list
4. **Speed Delta Commands** - `speedDelta` for increment/decrement
5. **Brightness Delta Commands** - `brightnessDelta` for increment/decrement

### Questions to Verify:
1. Are there any other endpoints available?
2. Is there a WebSocket or polling mechanism for real-time updates?
3. Are there any error codes/messages we should handle?
4. What's the rate limit on API calls?
5. Can multiple commands be sent in a single request?
6. Are there device-specific capabilities (e.g., some fans don't have lights)?

---

## Error Handling

Current error responses handled:
- 401 Unauthorized - Invalid credentials
- 403 Forbidden - Access denied
- 500 Server Error
- Network timeouts (10s)

Need to verify:
- Rate limiting errors
- Invalid command errors
- Device offline errors
