{{
    config(
        tags=['unit-test', 'bigquery', 'snowflake', 'postgres']
    )
}}

{% call dbt_unit_testing.test('incremental_model_1', 'full refresh test') %}
  {% call dbt_unit_testing.mock_ref ('model_for_incremental') %}
    select 10 as c1
    UNION ALL
    select 20 as c1
    UNION ALL
    select 30 as c1
  {% endcall %}
  {% call dbt_unit_testing.mock_ref ('incremental_model_1') %}
    select 15 as c1
    UNION ALL
    select 25 as c1
  {% endcall %}
  {% call dbt_unit_testing.expect() %}
    select 10 as c1
    UNION ALL
    select 20 as c1
    UNION ALL
    select 30 as c1
  {% endcall %}
{% endcall %}

UNION ALL

{% call dbt_unit_testing.test('incremental_model_1', 'should only replace "this"') %}
  {% call dbt_unit_testing.mock_ref ('model_for_incremental') %}
    select 10 as c1
  {% endcall %}
  {% call dbt_unit_testing.expect() %}
    select 10 as c1, '"postgres"."dbt_unit_testing_dbt_test__audit"."incremental_model"'
  {% endcall %}
{% endcall %}

UNION ALL

{% call dbt_unit_testing.test('incremental_model_1', 'incremental test', options={"run_as_incremental": "True"}) %}
  {% call dbt_unit_testing.mock_ref ('model_for_incremental') %}
    select 10 as c1
    UNION ALL
    select 20 as c1
    UNION ALL
    select 30 as c1
  {% endcall %}
  {% call dbt_unit_testing.mock_ref ('incremental_model_1') %}
    select 10 as c1
  {% endcall %}
  {% call dbt_unit_testing.expect() %}
    select 20 as c1
    UNION ALL
    select 30 as c1
  {% endcall %}
{% endcall %}
 