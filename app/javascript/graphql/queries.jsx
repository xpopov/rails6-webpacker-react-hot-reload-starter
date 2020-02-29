import gql from 'graphql-tag';

export const listOrders = gql`
  query($page: Int, $limit: Int, $selection: String!) {
    orders(page: $page, limit: $limit, selection: $selection)
    {
      id
      orderNumber
      email
      createdAt
      totalPrice
      status
    }
  }
`;

export const listProductVariants = gql`
  query {
    productVariants
    {
      id
      title
      sku
    }
  }
`;

export const listClients = gql`
  query($page: Int, $limit: Int) {
    clients(page: $page, limit: $limit)
    {
      id
      firstName
      lastName
    }
  }
`;

export const client = gql`
  query($id: ID!) {
    client(id: $id)
    {
      id
      firstName
      lastName
    }
  }
`;

export const listSettings = gql`
  query {
    settings
    {
      companyName
      identity
      notificationEmails
    }
  }
`;

export const dashboardStatus = gql`
  query {
    dashboardStatus {
      processing
      failed
      shipped
      cancelled
    }
  }
`;
