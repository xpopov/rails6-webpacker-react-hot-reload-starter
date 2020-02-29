// import { Button, Modal } from 'react-bootstrap'
import React from 'react'
import { confirmAlert } from 'react-confirm-alert'
import 'react-confirm-alert/src/react-confirm-alert.css'
import { useMutation }from 'react-apollo'
import { Button } from '@shopify/polaris'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faTrashAlt as faTrash } from '@fortawesome/free-solid-svg-icons'

import { listClients } from '../../../graphql/queries'
import { deleteClient } from '../../../graphql/mutations'

export default (props) => {
  const startWithDialog = () => confirmAlert({
    title: 'Confirm deletion',
    message: 'Are you sure you want to delete Client <' + props.client.firstName + '>?',
    buttons: [
      {
        label: 'Yes, Delete',
        onClick: () => doDeleteClient(props.client)
      },
      {
        label: 'Cancel',
        onClick: () => {}
      }
    ]
  });
  const onDeletionCompleted = ({deleteClient}) => {
    console.log(deleteClient);
    setTimeout(props.refetch, 100);
  }
  const [startDeletion, { data }] = useMutation(deleteClient, {
    onCompleted: onDeletionCompleted,
    // refetch works or not?
    // refetchQueries: [ { query: listClients } ],
    // awaitRefetchQueries: true
  });
  const doDeleteClient = (client) => {
    console.log(client);
    startDeletion({ variables: { id: client.id } });
  }
  
  return (
    <Button icon={<FontAwesomeIcon icon={faTrash} />}
            onClick={() => { startWithDialog(props.client) }}
    />
  );
}
