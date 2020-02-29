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
