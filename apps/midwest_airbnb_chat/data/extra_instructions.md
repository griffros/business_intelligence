# Extra Instructions

Rules the LLM follows when it writes SQL for `listings`.

- `price` is the nightly price in U.S. dollars. When the user asks what something costs, use `price` and round money to whole dollars in the answer.

- When comparing prices across cities or neighbourhoods, state the room type being compared and show the number of listings in each group. If the user does not specify a room type, compare Entire home/apt listings and clearly state that choice.

- Treat SQL NULL as missing information, not as zero or false. The host_since and instant_bookable columns are entirely NULL in this dataset; explain that questions requiring those fields cannot be answered from the available data.

- Describe estimated_revenue_l365d as estimated revenue, not verified earnings or profit. Do not interpret 365 minus availability_365 as booked nights, because hosts can also block dates.

