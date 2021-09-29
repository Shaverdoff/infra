# Template
### Numbers
| Name	| Arguments	| Returns	| Notes|
|---	|---	|---	|---		|
| humanize	| number or string	| string	| Converts a number to a more readable format, using metric prefixes.|
| humanize1024	| number or string	| string	| Like humanize, but uses 1024 as the base rather than 1000.|
| humanizeDuration	| number or string	| string	|Converts a duration in seconds to a more readable format.|
| humanizePercentage	| number or string	| string	| Converts a ratio value to a fraction of 100.|
| humanizeTimestamp	| number or string	|string	| Converts a Unix timestamp in seconds to a more readable format.|

```
# example of usage in rules:
will expire in {{ humanizeDuration $value }}
```
