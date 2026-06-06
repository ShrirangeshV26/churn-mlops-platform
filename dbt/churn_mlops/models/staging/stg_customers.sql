with source as (
    select * from {{ source('raw', 'customers') }}
),

staged as (
    select
        customerid                                    as customer_id,
        gender,
        seniorcitizen                                 as is_senior_citizen,
        case when partner = 'Yes' then 1 else 0 end   as has_partner,
        case when dependents = 'Yes' then 1 else 0 end as has_dependents,
        tenure                                        as tenure_months,
        case when phoneservice = 'Yes' then 1 else 0 end as has_phone_service,
        internetservice                               as internet_service_type,
        contract                                      as contract_type,
        case when paperlessbilling = 'Yes' then 1 else 0 end as is_paperless_billing,
        paymentmethod                                 as payment_method,
        monthlycharges                                as monthly_charges,
        case 
            when totalcharges = ' ' then 0 
            else cast(totalcharges as float) 
        end                                           as total_charges,
        case when churn = 'Yes' then 1 else 0 end     as is_churned
    from source
)

select * from staged