import {Body, Controller, Delete, Get, Inject, Param, Post, Put, Query, UseGuards} from '@nestjs/common';
import { PermissionGroupAdminService } from 'src/permission-group/services/PermissionGroup.admin.service';
import { PermissionGroup } from '../entities/PermissionGroup.entity';
import { PermissionGroupInputDto } from '../dtos/PermissionGroup.input.dto';
import {ApiBearerAuth, ApiBody, ApiOperation, ApiParam, ApiQuery, ApiResponse} from '@nestjs/swagger';
import {AuthGuard} from "../../auth/auth.guard";

@Controller('admin')
export class PermissionGroupAdminController {

    constructor(
        @Inject(PermissionGroupAdminService)
        private readonly permissionGroupService: PermissionGroupAdminService
    ) { }

    // 1. Get permission group  by role
    // GET /admin/permissions?role={role}
    @ApiOperation({
        summary: 'Get permissions by role',
        description: 'This endpoint retrieves the permission group associated with a specific role. ' +
            'You need to provide the role name as a query parameter. The API returns the associated permissions for the specified role.'
    })
    @ApiQuery({
        name: 'role',
        type: String,
        required: true,
        description: 'The name of the role for which permissions are being retrieved.',
    })
    @ApiResponse({
        status: 200,
        description: 'The permission group associated with the specified role has been successfully retrieved.',
        type: PermissionGroup,
        example: {
            "id": 4,
            "role": "Customer",
            "AccessControlSet": [
                { "action": { "read": true, "create": false, "delete": false, "update": false }, "resource": "post" },
                { "action": { "read": true, "create": true, "delete": true, "update": true }, "resource": "comment" }
            ]
        }
    })
    @ApiResponse({
        status: 404,
        description: 'Not Found. The specified role does not exist or has no associated permissions.',

    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @ApiBearerAuth() // Adds Bearer Auth for this endpoint
    @ApiBearerAuth('Authorization')
    @UseGuards(AuthGuard) // Ensure AuthGuard is properly implemented
    @Get('/permissions')
    getPermissionsByRole(@Query('role') role: string): Promise<PermissionGroup> {
        return this.permissionGroupService.findByRole(role);
    }

    // 2. Create group permissions for a new role
    // POST:  /admin/permissions/:role
    // role , permissions
    @ApiOperation({
        summary: 'Create a new role permission group',
        description: 'This endpoint allows for the creation of a new role along with its associated permission group. '
    })
    @ApiResponse({
        status: 201,
        description: 'The role permission group has been successfully created.',
        type: PermissionGroup,
        example: {
            "role": "Customer",
            "AccessControlSet": [
                { "resource": "post", "action": { "create": false, "read": true, "update": false, "delete": false } },
                { "resource": "comment", "action": { "create": true, "read": true, "update": true, "delete": true } }
            ]
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
    @Post('/permissions')
    newRolePermission(@Body() groupInputDto: PermissionGroupInputDto): Promise<PermissionGroup> {
        return this.permissionGroupService.createWithNewRole(groupInputDto);
    }

    // 3. Update group permissions by role
    // PUT:  /admin/permissions/{role}
    // role, permissions
    @ApiOperation({
        summary: 'Update permissions for a role',
        description: 'This endpoint updates the permissions associated with a specific role. '
    })
    @ApiBody({
        description: 'The data required to update permissions for a specific role. This includes the role name and the updated permissions.',
        type: PermissionGroupInputDto,
    })
    @ApiResponse({
        status: 200,
        description: 'The permissions for the role have been successfully updated.',
        type: PermissionGroup,
        example: {
            "role": "Customer",
            "AccessControlSet": [
                { "resource": "post", "action": { "create": false, "read": true, "update": false, "delete": false } },
                { "resource": "comment", "action": { "create": true, "read": true, "update": true, "delete": true } }
            ]
        }
    })
    @ApiResponse({
        status: 400,
        description: 'Bad Request. The input data is invalid or missing required fields.',
    })
    @ApiResponse({
        status: 404,
        description: 'Not Found. The specified role does not exist.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @Put('/permissions')
    updatePermissionForRole(@Body() groupInputDto: PermissionGroupInputDto): Promise<PermissionGroup> {
        return this.permissionGroupService.updateForRole(groupInputDto);
    }

    // 4. Delete role permission
    // DELETE: /admin/permissions/{role}
    @ApiOperation({
        summary: 'Delete a role permission',
        description: 'This endpoint allows for the deletion of a specific role permission group. '
    })
    @ApiParam({
        name: 'role',
        description: 'The name of the role whose permission group is to be deleted.',
        example: 'Customer'
    })
    @ApiResponse({
        status: 200,
        description: 'The role permission group has been successfully deleted.',
        example: {
            message: "Role permission for 'Customer' successfully deleted."
        }
    })
    @Delete('/permissions/:role')
    deleteRolPermission(@Param('role') role: string) {
        this.permissionGroupService.deleteGroup(role)
    }

    // 6*. Get list 
    // GET LIST: list group permissions 

}
