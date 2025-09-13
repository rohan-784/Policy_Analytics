use insurance;

# ALTER TABLE Policy_Details CHANGE COLUMN `policy_id` Policy_ID INT;
# ALTER TABLE additional_fields CHANGE COLUMN `ï»¿Agent_ID` Agent_ID INT;
# ALTER TABLE policy_data CHANGE COLUMN `ï»¿Customer_ID` Customer_ID INT;
# ALTER TABLE payment_history CHANGE COLUMN `ï»¿Payment_ID` Payment_ID INT;
# ALTER TABLE customers CHANGE COLUMN `ï»¿Customer_ID` Customer_ID INT;
# ALTER TABLE claims CHANGE COLUMN `ï»¿Claim_ID` Claim_ID INT;

-- ALTER TABLE policy_data ADD COLUMN tmp_end_date DATE;
-- UPDATE policy_data SET tmp_end_date = STR_TO_DATE(Policy_End_Date, '%d-%m-%Y');
-- ALTER TABLE policy_data DROP COLUMN Policy_End_Date;
-- ALTER TABLE policy_data CHANGE tmp_end_date Policy_End_Date DATE;

-- ALTER TABLE policy_details ADD COLUMN tmp_end_date DATE;
-- UPDATE policy_details SET tmp_end_date = STR_TO_DATE(Policy_End_Date, '%d-%m-%Y');
-- ALTER TABLE policy_details DROP COLUMN Policy_End_Date;
-- ALTER TABLE policy_details CHANGE tmp_end_date Policy_End_Date DATE;

-- UPDATE policy_data SET Date_of_Payment = STR_TO_DATE(Date_of_Payment, '%d-%m-%Y');
-- ALTER TABLE policy_data MODIFY COLUMN Date_of_Payment DATE;


# Total number of policies in the system (active and inactive)

with a as (
select policy_id, status from policy_details 
union all 
select policy_id, status from policy_data
)
select count(distinct Policy_ID) as Total_Policy, 
count(distinct case when status = "Active" then Policy_ID end) as Total_Active_Policy, 
count(distinct case when status <> "Active" then Policy_ID end) as Total_Inactive_Policy 
from a;


# Total count of customers who hold one or more policies

with a as (
select customer_id, policy_id from policy_details
union
select customer_id, policy_id from policy_data 
),
b as (
select customer_id, count(policy_id) as total_policy from a group by 1
)
select count(*) as Total_Customers,
count(case when total_policy>1 then 1 end) as Total_Customers_with_more_than_one_policy,
count(case when total_policy<=1 then 1 end) as Total_Customers_with_less_than_one_policy
from b;

# Policies grouped by customer age brackets (e.g., 18-25, 26-35)

with policies as (
select policy_id, customer_id from policy_details
union
select policy_id, customer_id from policy_data
)
select case
when b.age between 18 and 25 then "18-25"
when b.age between 26 and 35 then "26-35"
when b.age between 36 and 45 then "36-45"
when b.age between 46 and 60 then "46-60"
else "60+"
end as Age_Group, count(c.policy_id) as Total_Policies 
from policies as c join customers as b on c.customer_id = b.customer_id
group by 1 order by 1;

# OR

select case
when age between 18 and 25 then "18-25"
when age between 26 and 35 then "26-35"
when age between 36 and 45 then "36-45"
when age between 46 and 60 then "46-60"
else "60+"
end as Age_Group, count(policy_id) as Total_Policies 
from policy_data group by 1 order by 1;


# Number of policies categorized by gender (male, female, other)

with policies as (
select policy_id, customer_id from policy_data
union
select policy_id, customer_id from policy_details
)
select case
when b.gender = "Male" then "Male"
when b.gender = "Female" then "Female"
else "Others"
end as Gender, count(a.policy_id) as Total_Policies
from policies as a join customers as b on a.customer_id=b.customer_id
group by 1 order by 2;

# OR

select case 
when gender ="male" then "Male"
when gender = "female" then "Female"
else "Others"
end as Gender, count(policy_id) as Total_Policies
from policy_data group by 1 order by 2;


# Number of policies distributed by policy type

with a as(
select policy_id, policy_type from policy_data
union
select policy_id, policy_type from policy_details
)
select policy_type, count(policy_id) as Total_Policies from a group by 1 order by 2;


# Count of policies set to expire within the current calendar year

with a as(
select policy_id, Policy_End_Date from policy_data
union
select policy_id, Policy_End_Date from policy_details
)
select count(policy_id) as Total_Policies_Expiring_This_Year from a where year(Policy_End_Date) = year(current_date());

# OR

with a as (
    select policy_id, Policy_End_Date, policy_type from policy_data
    union
    select policy_id, Policy_End_Date, policy_type from policy_details
)
select monthname(Policy_End_Date) as Expiry_Month,
	   sum(case when policy_type ="Auto" then 1 else 0 end) as "Auto", 
	   sum(case when policy_type ="Health" then 1 else 0 end) as "Health", 
       sum(case when policy_type ="Life" then 1 else 0 end) as "Life", 
       sum(case when policy_type ="Property" then 1 else 0 end) as "Property", 
       count(policy_id) as Total_Policies
from a
where year(Policy_End_Date) = year(current_date())
group by 1, month(Policy_End_Date)
order by month(Policy_End_Date);


# Percentage increase in premium revenue over a specific time period

with a as (
select year(date_of_payment) as Years, sum(premium_amount) as Total_Amount from policy_data group by 1
)
select CY.years as Years, round(CY.Total_Amount,2) as CY_Amount, round(LY.Total_Amount,2) as LY_Amount, 
round(((CY.Total_Amount-LY.Total_Amount)/LY.Total_Amount)*100,2) as Growth_Rate
from a as CY left join a as LY on CY.years = LY.years+1 order by 1; 


# Count of policies grouped by claim status (e.g., approved, rejected, pending)

select claim_status, count(policy_id) as Total_Policies from claims group by 1 order by 2;

# Policies categorized by payment status (e.g., paid, overdue, pending)

select payment_status, count(policy_id) as Total_Polcies from payment_history group by 1 order by 2 ;

# Total amount paid for claims across all policies

with policies as (
select policy_id, policy_type from policy_data
union
select policy_id, policy_type from policy_details
)
select b.policy_type, sum(a.claim_amount) as Total_Amount_Paid 
from claims as a join policies as b on a.policy_id = b.policy_id 
where a.claim_status = "Approved" group by 1 order by 2;

# OR

select b.policy_type, sum(a.claim_amount) as Total_Amount_Paid from claims a join policy_data b on a.policy_id = b.policy_id
where a.claim_status = 'Approved' group by 1 order by 2;

