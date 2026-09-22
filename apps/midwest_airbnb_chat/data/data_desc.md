# Midwest Airbnb Listings: Data Dictionary

**Dataset:** `listings` table in `midwest_airbnb.db` (SQLite), 14,887 rows and 29 columns
**Source:** Inside Airbnb (https://insideairbnb.com/get-the-data/), the detailed `listings.csv.gz` file for each of three regions: Chicago (snapshot 2026-07-20), Columbus (snapshot 2026-07-23), and Twin Cities MSA (snapshot 2026-07-21). Column meanings follow Inside Airbnb's data dictionary and assumptions (https://insideairbnb.com/data-assumptions/).
**Course:** ISA 401, Miami University

> One row is one listing that showed a nightly price on the snapshot date; listings with no price were dropped. Empty cells are stored as SQL `NULL`.

---

## Field Definitions

| Field | Type | Description |
|---|---|---|
| `city` | text | Which Inside Airbnb region the listing came from: `Chicago` (7,439 rows), `Columbus` (2,587), or `Twin Cities` (4,861). The Twin Cities file covers the Minneapolis-St. Paul metro area, not just the two cities. |
| `snapshot_date` | text | Date Inside Airbnb compiled the file, stored as an ISO text string, not a date: `2026-07-20` for Chicago, `2026-07-23` for Columbus, `2026-07-21` for Twin Cities. Every row of a city shares the same value. |
| `id` | text | Airbnb's listing id. Unique across the table (14,887 distinct values). Stored as text even though it looks numeric, so compare it to a quoted string. |
| `name` | text | Listing title as shown on Airbnb (for example "Tiny Studio Apartment 94 Walk Score"). Never empty. |
| `price` | real | Nightly price in U.S. dollars on the snapshot date, with the dollar sign and commas removed. Ranges from 2.56 to 11,412; never `NULL` (rows without a price were dropped). |
| `room_type` | text | Airbnb's four listing categories: `Entire home/apt` (11,652 rows), `Private room` (2,951), `Hotel room` (246), or `Shared room` (38). |
| `host_id` | text | Host account identifier. Stored as text; compare with quoted strings. There are 6,970 distinct host IDs; one host can have multiple listings. |
| `host_name` | text | Host display name, such as `Rebecca`. Missing (`NULL`) in 25 rows. Use `host_id`, not names, to distinguish hosts. |
| `host_since` | text | Account registration date, not necessarily when hosting began. All 14,887 values are `NULL` in this database; host tenure cannot be calculated. |
| `host_is_superhost` | text | Superhost status: `'t'` means yes and `'f'` means no. Missing in 25 rows. Use quoted text values in SQL. |
| `neighbourhood` | text | Geographic area assigned by Inside Airbnb; renamed from `neighbourhood_cleansed`. Contains 119 distinct values, including `Hyde Park`. Group with `city` for regional comparisons. |
| `latitude` | real | Approximate north-south coordinate in decimal degrees (WGS84). Observed range: 39.8753494 to 46.24415. Not an exact property address. |
| `longitude` | real | Approximate east-west coordinate in decimal degrees (WGS84). Observed range: -94.52678887596865 to -82.7809534. Not an exact property address. |
| `property_type` | text | Detailed accommodation category. Contains 62 distinct values, such as `Entire rental unit` and `Private room in condo`. |
| `accommodates` | integer | Maximum guest capacity. Observed range: 1 to 16; no missing values. Capacity does not establish permission to host parties or events. |
| `bedrooms` | real | Bedroom count, stored as a real number in this database. Nonmissing values range from 1 to 16; 2,976 rows are `NULL`. Missing does not mean zero. |
| `beds` | real | Bed count, stored as a real number. Nonmissing values range from 1 to 32; 668 rows are `NULL`. Missing does not mean zero. |
| `bathrooms_text` | text | Bathroom description, such as `1 bath`, `1 shared bath`, or `1 private bath`. Missing in 71 rows. Contains text rather than a directly summable number. |
| `minimum_nights` | integer | Minimum required stay in nights; date-specific calendar rules may differ. Observed range: 1 to 365; missing in 15 rows. |
| `availability_365` | integer | Available nights in the next 365 days as of the snapshot. Ranges from 0 to 365. Unavailable nights may be booked or blocked; do not treat them all as booked nights. |
| `number_of_reviews` | integer | Total listing review count. Observed range: 0 to 2,246; no missing values. Reviews are not the same as bookings. |
| `number_of_reviews_ltm` | integer | Reviews in the preceding 12 months. Observed range: 0 to 1,220; no missing values. |
| `first_review` | text | Earliest review date, stored as `YYYY-MM-DD` text. Observed range: `2009-07-03` to `2026-07-20`; missing in 1,761 rows. |
| `last_review` | text | Most recent review date, stored as `YYYY-MM-DD` text. Observed range: `2014-08-23` to `2026-07-22`; missing in 1,761 rows. |
| `review_scores_rating` | real | Overall guest rating. Observed values range from 1 to 5; missing in 1,761 rows. Do not replace missing ratings with zero. |
| `reviews_per_month` | real | Average monthly review frequency over the listing's review history. Observed range: 0.01 to 77.72; missing in 1,761 rows. |
| `instant_bookable` | text | Whether booking requires host approval; source encoding is `'t'` for instant booking and `'f'` otherwise. All 14,887 values are `NULL` here, so this dataset cannot identify instantly bookable listings. |
| `estimated_revenue_l365d` | real | Estimated revenue for the preceding 365 days, in U.S. dollars. Observed range: 0 to 1,114,800; no missing values. Treat as an estimate, not verified earnings or profit. |
| `amenities_count` | integer | Course-computed count of items in the original amenities list. Observed range: 0 to 100; no missing values. This count does not identify which amenities a listing has. |