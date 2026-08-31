crashes_per_day = 30125 / 365
crashes_per_day

# Objects and vectors

crashes_by_day = c(
  2020,
  2241,
  2327,
  2285,
  2380,
  1866,
  1664
)

names(crashes_by_day) = c(
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun"
)

crashes_by_day

# Practice

crashes_by_day > 2000

sum(crashes_by_day > 2000)

mean(crashes_by_day)

# Checking data types

typeof(TRUE)
typeof(401L)
typeof(401)
typeof("401")

mixed_values = c(401, "ISA")
mixed_values
typeof(mixed_values)

# Data frames and lists

crashes_df = tibble::tibble(
  day = names(crashes_by_day),
  crashes = crashes_by_day,
  busy = crashes_by_day > 2000
)

crashes_df

nrow(crashes_df)
ncol(crashes_df)
names(crashes_df)
typeof(crashes_df)
str(crashes_df)

example_list = list(
  1:3,
  "a",
  c(TRUE, FALSE, TRUE),
  c(2.3, 5.9)
)

str(example_list)

str(example_list[1])
str(example_list[[1]])

example_list[[1]][[1]]
example_list[[4]][2]

# Examine a job advertisement

job = list(
  title = "Research Data Scientist, Magic Eye",
  company = "Google",
  salary = list(
    min = 147000,
    max = 210000
  )
)

str(job)

job$company
job$salary$max
job[["salary"]][["max"]]
names(job)

# Subsetting and indexing

crashes_by_day[2]

crashes_by_day["Fri"]

crashes_by_day[crashes_by_day > 2300]

crashes_by_day[c(1, 7)]

crashes_by_day[-1]

crashes_df$crashes

crashes_df[["crashes"]]

crashes_df[1:2, c("day", "crashes")]

# Functions

mean(x = crashes_by_day)

mean(x = crashes_by_day, trim = 0.2)

mean(x = c(1, 2, NA))

mean(x = c(1, 2, NA), na.rm = TRUE)

# Calculate each value as a percentage of the total

crash_share = function(x) {
  share = x / sum(x) * 100
  return(share)
}

crash_share(crashes_by_day)

round(
  x = crash_share(crashes_by_day),
  digits = 1
)

# Names of the days whose count beats a threshold.
# x: a named numeric vector
# threshold: the count to beat (default 2000)
# Returns a character vector of names.

busy_days = function(x, threshold = 2000) {
  above = names(x)[x > threshold]
  return(above)
}

busy_days(crashes_by_day)

busy_days(
  x = crashes_by_day,
  threshold = 2300
)

# Counts values that exceed a threshold.
# x: a numeric vector
# threshold: the value to exceed (default 2000)
# Returns the number of values above the threshold.

above = function(x, threshold = 2000) {
  count = sum(x > threshold)
  return(count)
}

above(crashes_by_day)

above(
  x = crashes_by_day,
  threshold = 2300
)

# Control flow

if (crashes_per_day > 80) {
  "a busy year"
} else {
  "a quiet year"
}

ifelse(
  test = crashes_df$crashes > 2000,
  yes = "busy",
  no = "quiet"
)

# Repeat an action for every day

for (day in names(crashes_by_day)) {
  cat(
    day,
    "had",
    crashes_by_day[day],
    "crashes.\n"
  )
}