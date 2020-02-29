import React from 'react'
// ButtonparseInt(, Modal) } from 'react-bootstrap'
import { useMutation }from 'react-apollo'
import { Button } from '@shopify/polaris'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faFileImport as faSend } from '@fortawesome/free-solid-svg-icons'

import { processOrder } from '../../../graphql/mutations'

console.log(processOrder)

export default (props) => {
  const onProcessingCompleted = ({order}) => {
    console.log(order);
    setTimeout(props.refetch, 100);
  }
  const [resendOrder, { data }] = useMutation(processOrder, {
    onCompleted: onProcessingCompleted,
  });
  const doProcessOrder = (order) => {
    console.log(order);
    resendOrder({ variables: { orderId: order.id } });
  }
  
  return (
    <Button accessibilityLabel="Process Action" icon={<FontAwesomeIcon icon={faSend} />}
            onClick={() => { doProcessOrder(props.order) }}
    >
      Submit
    </Button>
  );
}