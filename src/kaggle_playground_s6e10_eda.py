import polars as pl
import polars.selectors as cs
from plotnine import *

df_pth = "data/kaggle_airline_satisfaction.csv"

df_raw = pl.read_csv(df_pth)

df_raw.glimpse()
# ok, if we're actually modeling, 'satisfaction' is our output column 

n_obs = df_raw.shape[0]
p = df_raw.shape[1]

# let's take a look at the responses for satisfaction
df_raw['satisfaction'].sum() / n_obs
# ok, so 44% are satisfied

# we have lots of variables that seem to be likert scale
# let's take a look at those
likert_cols = df_raw.columns[3:16]
likert_cols.append("id")

likert_df = df_raw.select(likert_cols)

likert_df_long = likert_df.unpivot(index = "id")

f_hist = (
    ggplot(likert_df_long, aes(x = "value")) +
    geom_histogram(bins = 5) +
    facet_wrap("variable") +
    theme_minimal()
)

f_hist.show()
# ok, most seem to have positive sentiment. 3's are the most common answer across most questions

# i'm noticing a 'customer type' column
df_raw.group_by('Customer Type').len()
# most are loyal customers, and there are only 2 types -- loyal and dislocal

# let's look at type of travel and class
df_raw.group_by('Type of Travel').len()
# type of travel is just business or personal

df_raw.group_by('Class').len()
# class is eco, eco plus, and business

# and let's take a look at the distribution of departure/arrival delay
dep_delay_p = (
    ggplot(df_raw, aes(x = 'Departure Delay in Minutes')) +
    geom_histogram() +
    theme_minimal()
)

dep_delay_p.show()
# wonky distribution -- most values are 0

dep_delay_col = df_raw['Departure Delay in Minutes']
delay_0 = [i == 0 for i in dep_delay_col]
sum(delay_0) / len(delay_0)
# about 91% of departure delays are 0 mins

arr_delay_col = df_raw['Arrival Delay in Minutes']
arr_d_0 = [i == 0 for i in arr_delay_col]
sum(arr_d_0) / len(arr_d_0)
# 91.5% of arrival delays are 0