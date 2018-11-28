import gql from 'graphql-tag';

export default gql`
  query PlanChanges($plan_id: String, $coupon_code: String) {
    me {
      __typename
      id
      customer {
        __typename
        id
        plan {
          __typename
          id
          amount
        }
        upcoming_invoice(plan_id: $plan_id, coupon_code: $coupon_code) {
          __typename
          subtotal
          total
        }
      }
    }
  }
`;
