import gql from 'graphql-tag';

export const processOrder = gql`
  mutation($orderId: ID!) {
    processOrder(input: {
      orderId: $orderId
    }) {
      errors {
        message
      }
    }
  }
`;

export const updateSettings = gql`
  mutation($companyName: String!, $identity: String!, 
    $notificationEmails: String!) {
    updateSettings(input: {
      companyName: $companyName,
      identity: $identity,
      notificationEmails: $notificationEmails
    }) {
      errors {
        message
      }
    }
  }
`;
