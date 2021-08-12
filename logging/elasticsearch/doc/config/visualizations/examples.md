# RESPONSE CODES
```
Создаем визуализацию
Тип AREA from SAVED SEARCH  - FRONTEND
# Data
Y-AXIS
Создаем такие данные для каждого HTTP_STATUS_PAGE (200-299,300-399,etc.)

# BUCKETS
X-AXIS
 
В вкладке Metrics & axes
Выбираем тип NORMAL
Save with name [FRONTEND] – RESPONSE CODES
```

# Unique visitors
```
Type Gauge
Data source – saved search – FRONTEND
Metrics/Aggregation - Unique Count
Field - remote_addr.keyword 
# Вкладка Options
Ranges
0 1000
1000 3000
3000 6000
Color schema Green to Red
Click Reverse schema
```
# HTTP_Referer
Type Data table
Data source – save search – RV-FRONT
Metrics 
Aggregation – COUNT

Buckets
Type Split rows 
Aggregation – Terms
Field - http_referer.keyword
Save with name Referring site
```
# Visitors by OS
```
Type PIE
Data source – save search – RV-FRONT
Metrics 
Aggregation – COUNT
Buckets
Split Slices 
Aggregation – Terms
Save with name - Popular OS
```
# Top 10 Remote IP
```
Metrics 
Aggregation – COUNT
Buckets
Aggregation – Terms
field – Remote_addr
Order Descending 10
Traffic
Type Area
Data source – save search – RV FRONT
Metrics 
Aggregation – Average
Field – body_bytes_send (!!!should be type NUMERIC)
Bucket
X-AXIS
Aggregation – Date Histogram
Field - timestamp
Save with Traffic
```
# TOP 15 URL
```
Type Horizontal bars
Data source – save search – RV FRONT
Y-Axis Count
Buckets
Aggregation TERMS
Field – path.keyword
ORDER – descending 15
Save
```
# TOP 10 status
Type Horizontal bars
Data source – save search – RV FRONT
Y-AxisCount
Aggregation TERMS
Field – status_code
Order - descending 10
Save Top 10 Status code
```