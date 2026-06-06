with customers as (
    select * from {{ ref('stg_customers') }}
),

features as (
    select
        customer_id,
        gender,
        is_senior_citizen,
        has_partner,
        has_dependents,
        tenure_months,
        has_phone_service,
        internet_service_type,
        contract_type,
        is_paperless_billing,
        payment_method,
        monthly_charges,
        total_charges,

        -- Engineered features
        case 
            when tenure_months <= 12 then 'new'
            when tenure_months <= 24 then 'developing'
            when tenure_months <= 48 then 'established'
            else 'loyal'
        end as tenure_segment,

        case
            when monthly_charges < 35 then 'low'
            when monthly_charges < 65 then 'medium'
            else 'high'
        end as charge_segment,

        case
            when total_charges > 0 then round(monthly_charges / total_charges * 100, 2)
            else 0
        end as monthly_to_total_ratio,

        case
            when contract_type = 'Month-to-month' then 1 else 0
        end as is_monthly_contract,

        case
            when internet_service_type = 'Fiber optic' then 1 else 0
        end as has_fiber,

        case
            when payment_method = 'Electronic check' then 1 else 0
        end as is_electronic_check,

        -- Target variable
        is_churned

    from customers
)

select * from features