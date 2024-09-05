import { DynamoDB } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocument } from '@aws-sdk/lib-dynamodb';
import { randomUUID } from "crypto";

const dynamo = DynamoDBDocument.from(new DynamoDB());

/**
 * Validates the given event object.
 *
 * @param {Object} event - Event object.
 * @param {string} event.actionType - Action type. Must be one of 'backup' or 'delete'.
 * @param {string} [event.path] - Path to backup. Required for 'backup' actionType.
 * @param {string} [event.id] - ID to delete. Required for 'delete' actionType.
 *
 * @throws {Error} If the event object is invalid.
 */
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

/**
 * Writes an item to the given DynamoDB table.
 *
 * @param {Object} [params] - Parameters.
 * @param {string} [params.TableName] - Name of the DynamoDB table to write to.
 * @param {Object} [params.Item] - Item to write.
 *
 * @returns {Promise} A promise that fulfills with the result of the put operation.
 */
async function dynamoPut(params = {}) {
    const { TableName, Item } = params;
    return dynamo.put({ TableName, Item });
};


/**
 * Deletes an item from the given DynamoDB table.
 *
 * @param {Object} [params] - Parameters.
 * @param {string} [params.TableName] - Name of the DynamoDB table to delete from.
 * @param {string} [params.Id] - ID of the item to delete.
 *
 * @returns {Promise} A promise that fulfills with the result of the delete operation.
 */
async function dynamoDelete(params = {}) {
    const { TableName, Id } = params;
    return dynamo.delete({ TableName, Key: { id: Id } });
};

    /**
     * Handles AWS Lambda events.
     *
     * If the event has an `actionType` of 'backup', it will create a new item in the DynamoDB table
     * with an `id` of a UUIDv4, `date` of the current ISO string, and `actionType` set to 'backup'.
     * It will also set `path_to_script` to the value of `path` in the event.
     * If the event has an `actionType` of 'delete', it will delete the item with the `id` of the value of
     * `id` in the event.
     *
     * @param {Object} event - The event object passed to the AWS Lambda function.
     * @param {string} event.actionType - The type of action to perform. Can be either 'backup' or 'delete'.
     * @param {string} [event.path] - The path to the script to backup. Required for 'backup' actionType.
     * @param {string} [event.id] - The id of the item to delete. Required for 'delete' actionType.
     *
     * @returns {Object} A response object with a `statusCode` of 200 and a `body` containing a JSON
     * object with a `message` property.
     */
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
