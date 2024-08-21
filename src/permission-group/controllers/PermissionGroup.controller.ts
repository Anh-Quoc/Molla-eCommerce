import { Body, Controller, Get, Param, Post } from 'node_modules/@nestjs/common';
import { PermissionGroup } from '../entities/PermissionGroup.entity';
import { PermissionGroupAdminService } from '../services/PermissionGroup.admin.service';
import { ApiBody, ApiOperation, ApiParam, ApiResponse } from 'node_modules/@nestjs/swagger';

// @Controller('permissions')
export class PermissionsController {
  constructor(private permissionService: PermissionGroupAdminService) {}

  // @ApiOperation({
  //   summary: 'Retrieve all permissions for all users',
  //   description:
  //     'This endpoint retrieves a list of all permissions assigned to each user in the system. The response includes detailed information on permissions for every user.',
  // })
  // @ApiResponse({
  //   status: 200,
  //   description: 'Successfully retrieved all user permissions.',
  // })
  // @ApiResponse({
  //   status: 204,
  //   description: 'No content. No permissions found in the system.',
  // })
  // @ApiResponse({
  //   status: 500,
  //   description:
  //     'Internal server error. Failed to retrieve user permissions due to a server issue.',
  // })
  // @Get()
  // // Get all user permissions API
  // async findAll(): Promise<GroupPermission[]> {
  //   const permissions = await this.permissionService.findAll();
  //   return permissions;
  // }

  // @ApiOperation({
  //   summary: 'Retrieve a single permission by ID',
  //   description:
  //     'This endpoint retrieves the details of a permission specified by the given ID. Ensure the ID is valid and corresponds to an existing permission.',
  // })
  // @ApiParam({
  //   name: 'id',
  //   description: 'The unique identifier of the permission to retrieve.',
  //   example: 1,
  // })
  // @ApiResponse({
  //   status: 200,
  //   description: 'Successfully retrieved the permission.',
  // })
  // @ApiResponse({
  //   status: 404,
  //   description:
  //     'Permission not found. The provided ID does not match any existing permission.',
  // })
  // @ApiResponse({
  //   status: 400,
  //   description: 'Invalid ID format. Ensure the ID is in the correct format.',
  // })
  // @ApiResponse({
  //   status: 500,
  //   description:
  //     'Internal server error. The permission could not be retrieved due to a server issue.',
  // })
  // @Get(':id')
  // // Find one permission API
  // async findOne(@Param('id') id: number): Promise<GroupPermission> {
  //   const permission = await this.permissionService.findById(id);
  //   return permission;
  // }

  // @ApiOperation({
  //   summary: 'Retrieve permissions by role ID',
  //   description:
  //     'This endpoint retrieves a list of permissions associated with the specified role ID. Ensure the role ID is valid and corresponds to an existing role.',
  // })
  // @ApiParam({
  //   name: 'roleId',
  //   description:
  //     'The unique identifier of the role for which to retrieve permissions.',
  //   example: 1,
  // })
  // @ApiResponse({
  //   status: 200,
  //   description:
  //     'Successfully retrieved the permissions for the specified role.',
  // })
  // @ApiResponse({
  //   status: 404,
  //   description:
  //     'Role not found. The provided role ID does not match any existing role.',
  // })
  // @ApiResponse({
  //   status: 400,
  //   description:
  //     'Invalid role ID format. Ensure the role ID is in the correct format.',
  // })
  // @ApiResponse({
  //   status: 500,
  //   description:
  //     'Internal server error. The permissions could not be retrieved due to a server issue.',
  // })
  // @Get('by-role/:roleId')
  // // Find permissions by role ID API
  // async findByRoleId(@Param('role') roleId: string): Promise<GroupPermission[]> {
  //   const permissions = await this.permissionService.findByRole(roleId);

  //   return permissions;
  // }

  // @ApiOperation({
  //   summary: 'Create a new permission',
  //   description:
  //     'This endpoint allows you to create a new permission by providing the necessary details. Ensure that the permission data is correctly formatted and does not duplicate existing permissions.',
  // })
  // @ApiBody({
  //   description: 'Details of the new permission to be created.',
  //   type: CreateGroupPermissionDto, // Replace with your DTO class for permission creation
  // })
  // @ApiResponse({
  //   status: 201,
  //   description: 'Successfully created the new permission.',
  // })
  // @ApiResponse({
  //   status: 400,
  //   description:
  //     'Invalid input data. Ensure all required fields are provided and correctly formatted.',
  // })
  // @ApiResponse({
  //   status: 409,
  //   description:
  //     'Conflict. A permission with the same details may already exist.',
  // })
  // @ApiResponse({
  //   status: 500,
  //   description:
  //     'Internal server error. The permission could not be created due to a server issue.',
  // })
  // @Post()
  // // Create new permission API
  // async create(
  //   @Body() createPermissionDto: CreateGroupPermissionDto,
  // ): Promise<void> {
  //   const newPermission =
  //     await this.permissionService.create(createPermissionDto);
  // }
}
