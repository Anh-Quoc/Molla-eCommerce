import { Body, Controller, Get, Param, Post, Query, Req, UseGuards } from "@nestjs/common";
import { UsersService } from "../services/users.service";
import { ApiBody, ApiOperation, ApiParam, ApiProperty, ApiResponse } from "@nestjs/swagger";
import { UsersAdminService } from "../services/users.admin.service";
import { plainToClass } from "class-transformer";
import { User } from "../entities/User.entity";
import { CreateUserInputDto } from "../dtos/create-user.dto";
import { UserAdminResponseDto } from "../dtos/user.admin.response";
import {AuthGuard} from "../../auth/auth.guard";

@Controller('admin')
export class UsersAdminController {
  constructor(
    private readonly usersService: UsersService,
    private readonly userAdminService: UsersAdminService
) {}

    // 7. Get list of user by role
    // GET /admin/users?role={role}

    @ApiOperation({
        summary: 'Get list of users by role',
        description: 'This endpoint retrieves a list of users who are assigned to a specific role. ' +
                     'You need to provide the role name as a query parameter. The API returns an array of user objects associated with the specified role.'
    })
    @ApiParam({
        name: 'role',
        description: 'The name of the role to filter users by.',
        example: 'Admin'
    })
    @ApiResponse({
        status: 200,
        description: 'A list of users associated with the specified role has been successfully retrieved.',
        
    })
    @ApiResponse({
        status: 404,
        description: 'Not Found. No users are associated with the specified role.',
       
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @Get('/users')
    // @UseGuards(PermissionsGuard)
    // @CheckPermissions([PermissionAction.READ, "user"])
    getUsersByRole(@Query('role') role: string){
        return this.userAdminService.findByRole(role);
    }
    
    // 8. Get user profile
    // GET /admin/users?id={id}
    @ApiOperation({
        summary: 'Get user profile by ID',
        description: 'This endpoint retrieves the profile information of a specific user identified by their ID. '
    })
    @ApiParam({
        name: 'id',
        description: 'The unique identifier of the user whose profile is to be retrieved.',
        example: 123
    })
    @ApiResponse({
        status: 200,
        description: 'The user profile has been successfully retrieved.',
        type: User,
    })
    @ApiResponse({
        status: 404,
        description: 'Not Found. The user with the specified ID does not exist.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @Get('/users/:id')
    async getUserById(@Param('id') id: number): Promise<UserAdminResponseDto> {
        return plainToClass(UserAdminResponseDto, await this.userAdminService.findById(id));
    }

    @ApiOperation({
        summary: 'Create a new user',
        description: 'This endpoint allows for the creation of a new user. You need to provide the user details, including role and profile information, in the request body. ' +
                     'The API creates the new user and returns the details of the created user.'
    })
    @ApiBody({
        description: 'The data required to create a new user, including role and profile information.',
        type: CreateUserInputDto,       
    })
    @ApiResponse({
        status: 201,
        description: 'The new user has been successfully created.',
        type: User, 
        example: { 
            "email": "john.doe@example.com", 
            "password": "$2b$10$ot1CGTQEwet2oG/mecqEyuJQhKPS/B0AiHTWgqWibKwYsC/fic28a", 
            "permissionGroupId": 3, 
            "fullname": "John Doe", 
            "address": "123 Main St, Apt 4B, Springfield, IL 62704", 
            "phoneNumber": "1234567890", 
            "dateOfBirth": "1980-01-01", 
            "lastLogin": null, "id": 4, 
            "created_at": "2024-08-15T00:14:11.926Z", 
            "updated_at": "2024-08-15T00:14:11.926Z", 
            "isActive": true }       
    })
    @ApiResponse({
        status: 400,
        description: 'Bad Request. The input data is invalid or missing required fields.',
    })
    @ApiResponse({
        status: 500,
        description: 'Internal Server Error. An error occurred while processing the request.',
    })
    @Post('/users')
    createNewUser(@Body() createUserInputDto: CreateUserInputDto){
        return this.userAdminService.createNewUser(createUserInputDto);
    }
}