import gql from 'graphql-tag';

export default gql`
  fragment EmptyOrTips on Identifiable {
    ... on User {
      __typename
      id
      created_at(format: "%Y-%m-%dT%H:%M:%S.%L%z")
      is_me
    }

    ... on Group {
      __typename
      id
      is_current_user_a_member
    }
  }
`;
