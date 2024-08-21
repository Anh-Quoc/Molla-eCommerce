import {Body, Controller, Delete, Get, Inject, Param, Post, Put, Query, UseGuards} from '@nestjs/common';
import { PermissionGroupAdminService } from 'src/permission-group/services/PermissionGroup.admin.service';
import { PermissionGroup } from '../entities/PermissionGroup.entity';
import { PermissionGroupInputDto } from '../dtos/PermissionGroup.input.dto';
import {ApiBearerAuth, ApiBody, ApiOperation, ApiParam, ApiQuery, ApiResponse, ApiTags} from '@nestjs/swagger';
import {AuthGuard} from "../../auth/guards/auth.guard";

@Controller('admin')
export class PermissionGroupAdminController {

    constructor(
        @Inject(PermissionGroupAdminService)
        private readonly permissionGroupService: PermissionGroupAdminService
    ) { }

    // 1. Get permission group by id
    // GET /admin/permissions?id={id}
    @ApiOperation({
        summary: 'Get permission group by id',
        description: 'This endpoint retrieves the permission group associated with a specific id.'
    })
    @ApiTags('Admin')
    @ApiParam({
        name: 'id',
        type: String,
        description: 'The id of the permission group for which permissions are being retrieved.',
        required: true,
    })
    @ApiResponse({
        status: 200,
        description: 'The permission group associated with the specified id has been successfully retrieved.',
        schema: { // Used 'schema' instead of 'type' and 'example' for better documentation
            example: {
                "id": 4,
                "name": "Customer",
                "AccessControlSet": [
                    { "action": { "read": true, "create": false, "delete": false, "update": false }, "resource": "post" },
                    { "action": { "read": true, "create": true, "delete": true, "update": true }, "resource": "comment" }
                ]
            }
        }
    })
    @ApiResponse({
        status: 404,
        description: 'Not Found. The specified id does not exist or has no associated permissions.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @ApiBearerAuth() // Adds Bearer Auth for this endpoint
    @UseGuards(AuthGuard) // Ensure AuthGuard is properly implemented
    @Get('/permissions/:id')
    getPermissionsById(@Param('id') id: number): Promise<PermissionGroup> {
        return this.permissionGroupService.findById(id);
    }

    // 2. Create  permission group
    // POST:  /admin/permissions/:role
    // role , permissions
    @ApiOperation({
        summary: 'Create a new permission group',
        description: 'This endpoint allows for the creation of a new permission group.'
    })
    @ApiTags('Admin')
    @ApiResponse({
        status: 201,
        description: 'The permission group has been successfully created.',
        schema: { // Changed from 'type' to 'schema' to better define the response structure
            example: {
                "name": "Customer",
                "AccessControlSet": [
                    { "resource": "post", "action": { "create": false, "read": true, "update": false, "delete": false } },
                    { "resource": "comment", "action": { "create": true, "read": true, "update": true, "delete": true } }
                ]
            }
        }
    })
    @ApiResponse({
        status: 400,
        description: 'Bad Request. The input data is invalid or missing required fields.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @ApiBearerAuth() // Adds Bearer Auth for this endpoint
    @UseGuards(AuthGuard) // Ensure AuthGuard is properly implemented
    @Post('/permissions')
    newPermissionGroup(@Body() groupInputDto: PermissionGroupInputDto): Promise<PermissionGroup> {
        return this.permissionGroupService.createPermissionGroup(groupInputDto);
    }


// 3. Update group permissions by id
// PUT: /admin/permissions/{id}
    @ApiOperation({
        summary: 'Update permissions by id',
        description: 'This endpoint updates the permissions associated with a specific id.'
    })
    @ApiTags('Admin')
    @ApiBody({
        description: 'The data required to update permissions for a specific id.',
        type: PermissionGroupInputDto,
    })
    @ApiParam({
        name: 'id',
        type: String,
        description: 'The id of the permission group to update.',
        required: true,
    })
    @ApiResponse({
        status: 200,
        description: 'The permissions for the id have been successfully updated.',
        schema: { // Used 'schema' instead of 'type' to define the response structure and example
            example: {
                "name": "Customer",
                "AccessControlSet": [
                    { "resource": "post", "action": { "create": false, "read": true, "update": false, "delete": false } },
                    { "resource": "comment", "action": { "create": true, "read": true, "update": true, "delete": true } }
                ]
            }
        }
    })
    @ApiResponse({
        status: 400,
        description: 'Bad Request. The input data is invalid or missing required fields.',
    })
    @ApiResponse({
        status: 404,
        description: 'Not Found. The specified id does not exist.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @ApiBearerAuth() // Adds Bearer Auth for this endpoint
    @UseGuards(AuthGuard) // Ensure AuthGuard is properly implemented
    @Put('/permissions/:id')
    updatePermissionGroupById(
        @Param('id') id: number,
        @Body() groupInputDto: PermissionGroupInputDto
    ): Promise<PermissionGroup> {
        return this.permissionGroupService.updateById(id, groupInputDto);
    }

    // 4. Delete permission group by id
    // DELETE: /admin/permissions/{id}
    @ApiOperation({
        summary: 'Delete a permission group',
        description: 'This endpoint allows for the deletion of a specific permission group by id.'
    })
    @ApiTags('Admin')
    @ApiParam({
        name: 'id',
        description: 'The id of the permission group to be deleted.',
        example: 1,
        required: true,
    })
    @ApiResponse({
        status: 200,
        description: 'The permission group has been successfully deleted.',
        schema: {
            example: {
                message: "Permission group with id 1 is successfully deleted."
            }
        }
    })
    @ApiResponse({
        status: 404,
        description: 'Not Found. The specified permission group id does not exist.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @ApiBearerAuth()
    @UseGuards(AuthGuard)
    @Delete('/permissions/:id')
    async deletePermissionGroupById(@Param('id') id: number): Promise<{ message: string }> {
        const message = await this.permissionGroupService.deleteGroup(id);
        return { message };
    }

    // 6*. Get list 
    // GET LIST: list group permissions 

}
