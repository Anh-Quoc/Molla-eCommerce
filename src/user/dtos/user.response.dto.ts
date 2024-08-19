import { ApiProperty } from 'node_modules/@nestjs/swagger';
import { Expose, Type } from 'class-transformer';

export class UserResponseDto {

  // constructor(){

  // }

  // constructor(profile){
  //   this.id = profile.id;
  //   this.email = profile.email;
  //   this.fullname = profile.fullname;
  //   this.address = profile.address;
  //   this.phoneNumber = profile.phoneNumber;
  //   this.dateOfBirth = profile.dateOfBirth;
  //   this.roleId = profile.roleId;
  //   this.isActive = profile.isActive;
  // }

  @ApiProperty()
  @Expose()
  id: number;

  @ApiProperty()
  @Expose()
  email: string;

  @ApiProperty()
  @Expose()
  fullname: string;

  @ApiProperty()
  @Expose()
  address: string;

  @ApiProperty()
  @Expose()
  phoneNumber: string;

  @ApiProperty({
    type: Date,
  })
  @Expose()
  @Type(() => Date)
  dateOfBirth: Date;

  @ApiProperty()
  @Expose()
  roleId: number;

  @ApiProperty()
  @Expose()
  isActive: boolean;
}
