import { DynamoDB } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocument } from '@aws-sdk/lib-dynamodb';
import { randomUUID } from "crypto";

const dynamo = DynamoDBDocument.from(new DynamoDB());

function validateEvent(event) {
    const availableActionTypes = ['backup', 'delete'];

    if (!event.actionType) {
        throw new Error('actionType is required');
    }

    if (!availableActionTypes.includes(event.actionType)) {
        throw new Error('actionType must be one of the following: ' + availableActionTypes.join(', '));
    }

    if (event.actionType === 'backup' && !event.path) {
        throw new Error('path is required for backup actionType');
    }

    if (event.actionType === 'delete' && !event.id) {
        throw new Error('id is required for delete actionType');
    }
};

async function dynamoPut(params = {}) {
    const { TableName, Item } = params;
    return dynamo.put({ TableName, Item });
};

async function dynamoDelete(params = {}) {
    const { TableName, Id } = params;
    return dynamo.delete({ TableName, Key: { id: Id } });
};

export const handler = async (event) => {
    let responseMessage;
    const tableName = '';

    validateEvent(event);

    const { actionType, path, id: actionId } = event;
    const id = randomUUID();
    const date = new Date().toISOString();

    const item = {
        id,
        date,
        actionType
    };

    if (actionType === 'backup') {
        item.path_to_script = path;
        try {
            await dynamoPut({ TableName: tableName, Item: item });
            responseMessage = `Item with id ${id} was added to ${tableName}`;
        } catch (error) {
            responseMessage = `Item with id ${id} was not added to ${tableName}`;
        }
    };

    if (actionType === 'delete') {
        try {
            await dynamoDelete({ TableName: tableName, Id: actionId });
            responseMessage = `Item with id ${actionId} was deleted from ${tableName}`;
        } catch (error) {
            responseMessage = `Item with id ${actionId} was not found in ${tableName}`;
        }
    };

    return {
        statusCode: 200,
        body: JSON.stringify({
            message: responseMessage
        }),
    };
};
