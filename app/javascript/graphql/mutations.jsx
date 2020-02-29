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

export const createClient = gql`
  mutation($firstName: String!, $lastName: String!) {
    createClient(input: {
      firstName: $firstName, 
      lastName: $lastName,
    }) {
      client {
        id
      }
    }
  }
`;

export const updateClient = gql`
  mutation($id: ID!, $firstName: String!, $lastName: String!) {
    updateClient(input: {
      id: $id, 
      firstName: $firstName, 
      lastName: $lastName,
    })
    {
      errors {
        path
        message
      }
    }
  }
`;

export const deleteClient = gql`
  mutation($id: ID!) {
    deleteClient(input: {
      id: $id
    })
    {
      deletedId
    }
  }
`;
